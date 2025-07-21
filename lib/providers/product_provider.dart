// lib/providers/product_provider.dart
import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<Product> _displayedProducts = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _searchQuery = '';
  String? _selectedCategory; // Seçili kategori String olarak kalır

  static const int _itemsPerPage = 8;
  int _currentPage = 0;

  // Getters
  List<Product> get allProducts => _allProducts;
  List<Product> get filteredProducts => _filteredProducts;
  List<Product> get displayedProducts => _displayedProducts;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  int get currentPage => _currentPage;
  int get totalPages => (_filteredProducts.length / _itemsPerPage).ceil();
  int get itemsPerPage => _itemsPerPage;
  String? get selectedCategory => _selectedCategory;

  // Tüm ürünlerdeki benzersiz kategori listesini döndürür.
  // Her ürünün kategori listesindeki tüm kategorileri toplar.
  List<String> get availableCategories {
    final Set<String> categories = {};
    for (var product in _allProducts) {
      categories.addAll(product.category); // Her ürünün kategori listesini ekle
    }
    return categories.toList()..sort(); // Alfabetik sıraya göre sırala
  }

  // State setters
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _updateDisplayedProducts() {
    int startIndex = _currentPage * _itemsPerPage;
    int endIndex =
        (startIndex + _itemsPerPage).clamp(0, _filteredProducts.length);
    _displayedProducts = _filteredProducts.sublist(startIndex, endIndex);
    notifyListeners();
  }

  // Public methods
  Future<void> loadProducts() async {
    _setLoading(true);
    _setError('');

    try {
      final loadedProducts = await ProductService.fetchProducts();
      _allProducts = loadedProducts;
      _applyFilters(); // Ürünler yüklendiğinde filtreleri uygula
      _currentPage = 0;
      _updateDisplayedProducts();
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  void searchProducts(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters(); // Arama sorgusu değiştiğinde filtreleri uygula
    _currentPage = 0;
    _updateDisplayedProducts();
  }

  void selectCategory(String? category) {
    _selectedCategory = category;
    _applyFilters(); // Kategori değiştiğinde filtreleri uygula
    _currentPage = 0;
    _updateDisplayedProducts();
  }

  // Yeni: Filtreleme mantığını tek bir metodda topladık
  void _applyFilters() {
    List<Product> tempProducts = _allProducts;

    // Arama sorgusuna göre filtreleme
    if (_searchQuery.isNotEmpty) {
      tempProducts = tempProducts.where((product) {
        // Herhangi bir kategorinin arama sorgusunu içerip içermediğini kontrol et
        final categoryMatches = product.category
            .any((cat) => cat.toLowerCase().contains(_searchQuery));
        return product.name.toLowerCase().contains(_searchQuery) ||
            categoryMatches || // Kategori listesinde arama
            product.code.toLowerCase().contains(_searchQuery) ||
            product.coding.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    // Kategoriye göre filtreleme
    if (_selectedCategory != null && _selectedCategory != 'Tümü') {
      tempProducts = tempProducts.where((product) {
        // Ürünün kategori listesi, seçili kategoriyi içeriyor mu?
        return product.category.contains(_selectedCategory);
      }).toList();
    }

    _filteredProducts = tempProducts;
  }

  void goToPage(int page) {
    if (page >= 0 && page < totalPages) {
      _currentPage = page;
      _updateDisplayedProducts();
    }
  }

  void clearSearch() {
    _searchQuery = '';
    _applyFilters(); // Aramayı temizlediğinde filtreleri uygula
    _currentPage = 0;
    _updateDisplayedProducts();
  }
}
