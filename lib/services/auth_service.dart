import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/tables/uyeler.dart';

class AuthService {
  // Mock users listesi
  static List<TabloUyeler> _mockUsers = [];

  // Mock users'ı yükle
  static Future<void> loadMockUsers() async {
    if (_mockUsers.isEmpty) {
      try {
        final String jsonString =
            await rootBundle.loadString('assets/data/mock_users.json');
        final List<dynamic> jsonList = json.decode(jsonString);
        _mockUsers =
            jsonList.map((json) => TabloUyeler.fromJson(json)).toList();
        print('Mock kullanıcılar yüklendi: ${_mockUsers.length} adet');
      } catch (e) {
        print('Mock kullanıcılar yüklenemedi: $e');
        // Varsayılan kullanıcılar
        _mockUsers = [
          TabloUyeler(
            id: 1,
            ad: 'Demo',
            soyad: 'Kullanıcı',
            email: 'demo@webofisi.com',
            sifre: 'demo123',
            telefon: '5551234567',
            statu: 1,
            durum: 1,
          ),
        ];
      }
    }
  }

  // Giriş yapma (Mock)
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    // Mock delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock users'ı yükle
    await loadMockUsers();

    /**
     
      await loadMockUsers();
      final user = _mockUsers.firstWhere(...);
  
      Gelecekte:
      final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );
  
      if (response.statusCode == 200) {
      final data = json.decode(response.body);
        return {
        'success': true,
        'token': data['token'],        // Gerçek JWT
        'user': TabloUyeler.fromJson(data['user']),
    };
  }
}
     */

    try {
      // Kullanıcıyı bul
      final user = _mockUsers.firstWhere(
        (u) => u.email == email && u.sifre == password,
        orElse: () => TabloUyeler(id: -1, email: '', sifre: ''),
      );

      if (user.id != -1) {
        // Başarılı giriş
        final token = _generateMockToken(user.id);

        return {
          'success': true,
          'token': token,
          'user': user,
          'message': 'Giriş başarılı!'
        };
      } else {
        return {'success': false, 'message': 'E-posta veya şifre hatalı!'};
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Giriş işlemi sırasında bir hata oluştu: $e'
      };
    }
  }

  // Kayıt olma (Mock)
  static Future<Map<String, dynamic>> register(TabloUyeler newUser) async {
    // Mock delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock users'ı yükle
    await loadMockUsers();

    // E-posta kontrolü
    if (_mockUsers.any((user) => user.email == newUser.email)) {
      return {
        'success': false,
        'message': 'Bu e-posta adresi zaten kullanılıyor!'
      };
    }

    // Yeni kullanıcıya ID ata
    final maxId = _mockUsers.isEmpty
        ? 0
        : _mockUsers.map((u) => u.id).reduce((a, b) => a > b ? a : b);
    final userWithId = TabloUyeler(
      id: maxId + 1,
      ad: newUser.ad,
      soyad: newUser.soyad,
      email: newUser.email,
      sifre: newUser.sifre,
      telefon: newUser.telefon,
      statu: 0, // Yeni kullanıcı normal statüde başlar
      durum: 1, // Aktif
      emailonay: 0, // E-posta onayı bekliyor
      tarih: DateTime.now().toIso8601String(),
    );

    // Listeye ekle (sadece session için, kalıcı değil)
    _mockUsers.add(userWithId);

    // Token oluştur
    final token = _generateMockToken(userWithId.id);

    return {
      'success': true,
      'token': token,
      'user': userWithId,
      'message': 'Kayıt başarılı! Hoş geldiniz!'
    };
  }

  // Mock token oluştur
  static String _generateMockToken(int userId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final token = 'mock_token_${userId}_$timestamp';

    // Gerçek JWT formatına benzer bir token oluştur (görsellik için)
    final header = base64.encode(utf8.encode('{"alg":"HS256","typ":"JWT"}'));
    final payload =
        base64.encode(utf8.encode('{"userId":$userId,"exp":$timestamp}'));
    final signature = base64.encode(utf8.encode('mock_signature'));

    return '$header.$payload.$signature';
  }

  // Token doğrulama (Mock)
  static Future<bool> validateToken(String token) async {
    // Mock için her zaman geçerli
    return token.startsWith('mock_token_') || token.contains('.');
  }

  // Şifre sıfırlama (Mock)
  static Future<Map<String, dynamic>> resetPassword(String email) async {
    await Future.delayed(const Duration(milliseconds: 800));

    await loadMockUsers();

    final userExists = _mockUsers.any((user) => user.email == email);

    if (userExists) {
      return {
        'success': true,
        'message': 'Şifre sıfırlama bağlantısı e-posta adresinize gönderildi.'
      };
    } else {
      return {
        'success': false,
        'message': 'Bu e-posta adresi sistemde kayıtlı değil.'
      };
    }
  }

  // E-posta doğrulama (Mock)
  static Future<bool> verifyEmail(String code) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock için basit kontrol
    return code.length == 6;
  }
}
