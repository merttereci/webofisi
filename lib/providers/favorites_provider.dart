import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../services/mock_api_service.dart';

class FavoritesProvider extends ChangeNotifier {
  final Set<int> _favoriteIds = <int>{};
  bool _isLoading = false;
  String? _error;

  // Getters
  Set<int> get favoriteIds => _favoriteIds;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get favoriteCount => _favoriteIds.length;

  // Favoriler listesini yükle (user_id gerekli)
  Future<void> loadFavorites(int userId) async {
    _setLoading(true);
    try {
      final favoriteScriptIds = await MockApiService.getUserFavorites(userId);
      _favoriteIds.clear();
      _favoriteIds.addAll(favoriteScriptIds);

      // SharedPreferences'a kaydet
      await _saveFavoritesToLocal();
      _clearError();
    } catch (e) {
      _setError('Favoriler yüklenirken hata: $e');
      // Local'den yükle
      await _loadFavoritesFromLocal();
    } finally {
      _setLoading(false);
    }
  }

  // Favori ekle/çıkar toggle
  Future<bool> toggleFavorite(int userId, int scriptId) async {
    final isCurrentlyFavorite = _favoriteIds.contains(scriptId);

    // Optimistic update
    if (isCurrentlyFavorite) {
      _favoriteIds.remove(scriptId);
    } else {
      _favoriteIds.add(scriptId);
    }
    notifyListeners();

    try {
      if (isCurrentlyFavorite) {
        // Favorilerden çıkar
        await MockApiService.removeFromFavorites(userId, scriptId);
      } else {
        // Favorilere ekle
        await MockApiService.addToFavorites(userId, scriptId);
      }

      // Başarılı işlemden sonra local'e kaydet
      await _saveFavoritesToLocal();
      _clearError();
      return true;
    } catch (e) {
      // Hata durumunda geri al
      if (isCurrentlyFavorite) {
        _favoriteIds.add(scriptId);
      } else {
        _favoriteIds.remove(scriptId);
      }
      notifyListeners();
      _setError('Favori güncellenirken hata: $e');
      return false;
    }
  }

  // Favorileri temizle (logout için)
  void clearFavorites() {
    _favoriteIds.clear();
    notifyListeners();
  }

  // Favori kontrolü
  bool isFavorite(int scriptId) {
    return _favoriteIds.contains(scriptId);
  }

  // Local storage'a kaydet
  Future<void> _saveFavoritesToLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesList = _favoriteIds.toList();
      await prefs.setString('favorites', json.encode(favoritesList));
    } catch (e) {
      debugPrint('Favoriler local\'e kaydedilirken hata: $e');
    }
  }

  // Local storage'dan yükle
  Future<void> _loadFavoritesFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesString = prefs.getString('favorites');

      if (favoritesString != null) {
        final favoritesList = List<int>.from(json.decode(favoritesString));
        _favoriteIds.clear();
        _favoriteIds.addAll(favoritesList);
      }
    } catch (e) {
      debugPrint('Favoriler local\'den yüklenirken hata: $e');
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  // Debug için
  void printFavorites() {
    debugPrint('Favori script ID\'leri: $_favoriteIds');
  }
}
