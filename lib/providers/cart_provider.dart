// lib/providers/cart_provider.dart - Hosting desteği eklendi

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/hosting_cart_item.dart';

class CartProvider extends ChangeNotifier {
  Set<int> _cartItems = {}; // Script ID'leri (mevcut sistem)
  List<HostingCartItem> _hostingItems = []; // Hosting items (yeni)
  bool _isLoading = false;

  // Getters - Scripts (mevcut)
  Set<int> get cartItems => Set.unmodifiable(_cartItems);
  bool get isLoading => _isLoading;
  int get scriptItemCount => _cartItems.length;
  bool get isEmpty => _cartItems.isEmpty && _hostingItems.isEmpty;
  bool get isNotEmpty => _cartItems.isNotEmpty || _hostingItems.isNotEmpty;

  // Getters - Hosting (yeni)
  List<HostingCartItem> get hostingItems => List.unmodifiable(_hostingItems);
  int get hostingItemCount => _hostingItems.length;

  // Getters - Combined
  int get totalItemCount => scriptItemCount + hostingItemCount;
  int get itemCount => totalItemCount; // Compatibility için

  // Constructor
  CartProvider() {
    _loadCartFromStorage();
  }

  // ====== SCRIPT METHODS (Mevcut - Değişiklik Yok) ======

  bool isInCart(int productId) {
    return _cartItems.contains(productId);
  }

  void toggleCart(int productId) {
    if (_cartItems.contains(productId)) {
      _cartItems.remove(productId);
      print('Sepetten çıkarıldı: ID $productId');
    } else {
      _cartItems.add(productId);
      print('Sepete eklendi: ID $productId');
    }

    _saveCartToStorage();
    notifyListeners();
  }

  void addToCart(int productId) {
    if (!_cartItems.contains(productId)) {
      _cartItems.add(productId);
      _saveCartToStorage();
      notifyListeners();
      print('Sepete eklendi: ID $productId');
    }
  }

  void removeFromCart(int productId) {
    _cartItems.remove(productId);
    _saveCartToStorage();
    notifyListeners();
    print('Sepetten çıkarıldı: ID $productId');
  }

  List<dynamic> getCartProducts(List<dynamic> allProducts) {
    return _cartItems
        .map((productId) {
          try {
            return allProducts.firstWhere((p) => p.id == productId);
          } catch (e) {
            print('Sepette olmayan ürün ID: $productId');
            return null;
          }
        })
        .where((product) => product != null)
        .toList();
  }

  // ====== HOSTING METHODS (Yeni) ======

  bool isHostingInCart(String packageId, String domain) {
    return _hostingItems
        .any((item) => item.packageId == packageId && item.domain == domain);
  }

  void addHostingToCart(HostingCartItem hostingItem) {
    // Aynı paket + domain kombinasyonu varsa güncelle
    final existingIndex = _hostingItems.indexWhere((item) =>
        item.packageId == hostingItem.packageId &&
        item.domain == hostingItem.domain);

    if (existingIndex != -1) {
      _hostingItems[existingIndex] = hostingItem;
      print('Hosting güncellendi: ${hostingItem.summary}');
    } else {
      _hostingItems.add(hostingItem);
      print('Hosting sepete eklendi: ${hostingItem.summary}');
    }

    _saveCartToStorage();
    notifyListeners();
  }

  void removeHostingFromCart(String packageId, String domain) {
    _hostingItems.removeWhere(
        (item) => item.packageId == packageId && item.domain == domain);

    _saveCartToStorage();
    notifyListeners();
    print('Hosting sepetten çıkarıldı: $packageId - $domain');
  }

  void removeHostingById(String uniqueId) {
    _hostingItems.removeWhere((item) => item.uniqueId == uniqueId);
    _saveCartToStorage();
    notifyListeners();
    print('Hosting sepetten çıkarıldı: $uniqueId');
  }

  // ====== COMBINED METHODS ======

  void clearCart() {
    _cartItems.clear();
    _hostingItems.clear();
    _saveCartToStorage();
    notifyListeners();
    print('Sepet tamamen temizlendi');
  }

  void clearScriptCart() {
    _cartItems.clear();
    _saveCartToStorage();
    notifyListeners();
    print('Script sepeti temizlendi');
  }

  void clearHostingCart() {
    _hostingItems.clear();
    _saveCartToStorage();
    notifyListeners();
    print('Hosting sepeti temizlendi');
  }

  // ====== PRICE CALCULATION METHODS ======

  // Scripts toplam (mevcut sistem - KDV hariç)
  double getScriptSubtotal(List<dynamic> allProducts) {
    double subtotal = 0;
    for (var productId in _cartItems) {
      try {
        final product = allProducts.firstWhere((p) => p.id == productId);
        subtotal += product.price;
      } catch (e) {
        continue;
      }
    }
    return subtotal;
  }

  // Scripts KDV tutarı
  double getScriptKdvAmount(List<dynamic> allProducts) {
    return getScriptSubtotal(allProducts) * 0.20;
  }

  // Scripts toplam (KDV dahil)
  double getScriptTotalAmount(List<dynamic> allProducts) {
    double subtotal = getScriptSubtotal(allProducts);
    return subtotal + (subtotal * 0.20);
  }

  // Hosting toplam (KDV zaten dahil)
  double getHostingTotalAmount() {
    return _hostingItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  // Genel toplam (Scripts + Hosting)
  double getGrandTotal(List<dynamic> allProducts) {
    double scriptTotal = getScriptTotalAmount(allProducts);
    double hostingTotal = getHostingTotalAmount();
    return scriptTotal + hostingTotal;
  }

  // Backward compatibility için eski metodlar
  double getSubtotal(List<dynamic> allProducts) {
    return getScriptSubtotal(allProducts);
  }

  double getKdvAmount(List<dynamic> allProducts) {
    return getScriptKdvAmount(allProducts);
  }

  double getTotalAmount(List<dynamic> allProducts) {
    return getGrandTotal(allProducts);
  }

  // ====== STORAGE METHODS ======

  Future<void> _saveCartToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Scripts kaydet (mevcut sistem)
      final scriptList = _cartItems.toList();
      await prefs.setString('cart_items', json.encode(scriptList));

      // Hosting kaydet (yeni)
      final hostingList = _hostingItems.map((item) => item.toJson()).toList();
      await prefs.setString('hosting_items', json.encode(hostingList));
    } catch (e) {
      print('Sepet kaydedilemedi: $e');
    }
  }

  Future<void> _loadCartFromStorage() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();

      // Scripts yükle (mevcut sistem)
      final cartString = prefs.getString('cart_items');
      if (cartString != null) {
        final cartList = List<int>.from(json.decode(cartString));
        _cartItems = cartList.toSet();
      }

      // Hosting yükle (yeni)
      final hostingString = prefs.getString('hosting_items');
      if (hostingString != null) {
        final hostingList =
            List<Map<String, dynamic>>.from(json.decode(hostingString));
        _hostingItems =
            hostingList.map((item) => HostingCartItem.fromJson(item)).toList();
      }

      print(
          'Sepet yüklendi: ${_cartItems.length} script, ${_hostingItems.length} hosting');
    } catch (e) {
      print('Sepet yüklenemedi: $e');
      _cartItems = {};
      _hostingItems = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  // ====== DEBUG METHODS ======

  void printCartContents() {
    print('=== SEPET İÇERİK ===');
    print('Scripts: $_cartItems');
    print('Hosting items: ${_hostingItems.length}');
    for (var item in _hostingItems) {
      print('  - ${item.summary} (${item.totalPrice}₺)');
    }
    print('==================');
  }
}
