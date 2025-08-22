// lib/providers/cart_provider.dart - Basitleştirilmiş versiyon

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartProvider extends ChangeNotifier {
  Set<int> _cartItems = {}; // Set kullanarak sadece ID'leri tut
  bool _isLoading = false;

  // Getters
  Set<int> get cartItems => Set.unmodifiable(_cartItems);
  bool get isLoading => _isLoading;
  int get itemCount => _cartItems.length; // Toplam farklı ürün sayısı
  bool get isEmpty => _cartItems.isEmpty;
  bool get isNotEmpty => _cartItems.isNotEmpty;

  // Constructor
  CartProvider() {
    _loadCartFromStorage();
  }

  // Ürün sepette var mı?
  bool isInCart(int productId) {
    return _cartItems.contains(productId);
  }

  // Sepete ürün ekle (toggle mantığı)
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

  // Sepete ürün ekle (manuel)
  void addToCart(int productId) {
    if (!_cartItems.contains(productId)) {
      _cartItems.add(productId);
      _saveCartToStorage();
      notifyListeners();
      print('Sepete eklendi: ID $productId');
    }
  }

  // Sepetten ürün çıkar
  void removeFromCart(int productId) {
    _cartItems.remove(productId);
    _saveCartToStorage();
    notifyListeners();
    print('Sepetten çıkarıldı: ID $productId');
  }

  // Sepeti temizle
  void clearCart() {
    _cartItems.clear();
    _saveCartToStorage();
    notifyListeners();
    print('Sepet temizlendi');
  }

  // Sepetteki ürünleri Product listesi olarak al
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

  // Toplam tutarı hesapla (her ürün quantity=1) + %20 KDV
  double getTotalAmount(List<dynamic> allProducts) {
    double subtotal = 0;
    for (var productId in _cartItems) {
      try {
        final product = allProducts.firstWhere((p) => p.id == productId);
        subtotal += product.price; // Quantity yok, direkt fiyat ekle
      } catch (e) {
        print('Fiyat hesaplanamayan ürün ID: $productId');
        continue;
      }
    }

    // %20 KDV ekle
    double kdv = subtotal * 0.20;
    double total = subtotal + kdv;

    print('Ara Toplam: ${subtotal.toStringAsFixed(2)} TL');
    print('KDV (%20): ${kdv.toStringAsFixed(2)} TL');
    print('Genel Toplam: ${total.toStringAsFixed(2)} TL');

    return total;
  }

  // Ara toplam (KDV hariç)
  double getSubtotal(List<dynamic> allProducts) {
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

  // KDV tutarı
  double getKdvAmount(List<dynamic> allProducts) {
    return getSubtotal(allProducts) * 0.20;
  }

  // SharedPreferences'a kaydet
  Future<void> _saveCartToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartList = _cartItems.toList(); // Set'i List'e çevir
      await prefs.setString('cart_items', json.encode(cartList));
    } catch (e) {
      print('Sepet kaydedilemedi: $e');
    }
  }

  // SharedPreferences'tan yükle
  Future<void> _loadCartFromStorage() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final cartString = prefs.getString('cart_items');

      if (cartString != null) {
        final cartList = List<int>.from(json.decode(cartString));
        _cartItems = cartList.toSet(); // List'i Set'e çevir
        print('Sepet yüklendi: ${_cartItems.length} ürün');
      }
    } catch (e) {
      print('Sepet yüklenemedi: $e');
      _cartItems = {};
    }

    _isLoading = false;
    notifyListeners();
  }
}
