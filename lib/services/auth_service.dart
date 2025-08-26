import 'dart:convert';
import '../models/tables/uyeler.dart';
import 'mock_api_service.dart'; // YENİ IMPORT

class AuthService {
  // Artık Mock API Server kullanıyoruz - asset JSON değil!

  // Giriş yapma (Mock API Server)
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    // Mock delay
    await Future.delayed(const Duration(milliseconds: 800));

    try {
      print('🔐 AuthService: Login denemesi - $email');

      // Mock API Server'dan kullanıcı ara
      final userData = await MockApiService.loginUser(email, password);

      if (userData != null) {
        print(
            '✅ AuthService: Kullanıcı bulundu - ${userData['ad']} ${userData['soyad']}');
        print(
            '👤 User ID: ${userData['id']} (Type: ${userData['id'].runtimeType})');

        // TabloUyeler modeline çevir - ID'yi olduğu gibi bırak
        final user = TabloUyeler.fromJson(userData);

        // Token oluştur
        final token = _generateMockToken(user.id);

        return {
          'success': true,
          'token': token,
          'user': user,
          'message': 'Giriş başarılı!'
        };
      } else {
        print('❌ AuthService: Kullanıcı bulunamadı');
        return {'success': false, 'message': 'E-posta veya şifre hatalı!'};
      }
    } catch (e) {
      print('❌ AuthService Login Error: $e');
      return {
        'success': false,
        'message': 'Giriş işlemi sırasında bir hata oluştu: $e'
      };
    }
  }

  // Kayıt olma (Mock API Server)
  static Future<Map<String, dynamic>> register(TabloUyeler newUser) async {
    // Mock delay
    await Future.delayed(const Duration(milliseconds: 800));

    try {
      print('📝 AuthService: Mock API ile register deneniyor...');
      print('📧 Email: ${newUser.email}');

      // Önce e-posta kontrolü yap
      final existingUser =
          await MockApiService.loginUser(newUser.email!, 'dummy_password');
      if (existingUser != null) {
        print('❌ AuthService: E-posta zaten kullanılıyor');
        return {
          'success': false,
          'message': 'Bu e-posta adresi zaten kullanılıyor!'
        };
      }

      // Yeni kullanıcı verisini hazırla
      final userData = {
        // ID'yi JSON-server otomatik atamasına izin ver
        'fbid': 0,
        'hesap': 1,
        'vergi': 1,
        'ad': newUser.ad,
        'soyad': newUser.soyad,
        'email': newUser.email,
        'telefon': newUser.telefon,
        'sifre': newUser.sifre,
        'resim': '',
        'il': newUser.il ?? '', // newUser'dan al
        'ilce': newUser.ilce ?? '', // newUser'dan al
        'adres': newUser.adres ?? '', // newUser'dan al
        'tc': newUser.tc ?? '', // newUser'dan al
        'firmaadi': newUser.firmaadi ?? '',
        'vergino': newUser.vergino ?? '',
        'vergidairesi': newUser.vergidairesi ?? '',
        'firma_tel': '',
        'firma_adres': '',
        'kampanya_eposta': newUser.kampanya_eposta ?? 0, // user tercihini al
        'kampanya_sms': newUser.kampanya_sms ?? 0,
        'indirim': '0',
        'statu': 0,
        'durum': 1,
        'ceponay': 0,
        'cepkod': '',
        'emailonay': 0,
        'emailkod': '',
        'son_giris': DateTime.now().toString(),
        'tarih': DateTime.now().toString(),
        'ay': DateTime.now().month.toString().padLeft(2, '0'),
        'ktarih': DateTime.now().toString().split(' ')[0],
        'parasutuyeid': 0,
        'vatandas': 1,
        'vip': 0,
        'mnot': '',
        'ip': '127.0.0.1',
      };

      // Mock API Server'a yeni kullanıcı ekle
      final createdUser = await MockApiService.registerUser(userData);

      print(
          '✅ AuthService: Kullanıcı oluşturuldu - ID: ${createdUser['id']} (Type: ${createdUser['id'].runtimeType})');

      // TabloUyeler modeline çevir - ID'yi olduğu gibi bırak
      final user = TabloUyeler.fromJson(createdUser);

      // Token oluştur
      final token = _generateMockToken(user.id);

      return {
        'success': true,
        'token': token,
        'user': user,
        'message': 'Kayıt başarılı! Hoş geldiniz!'
      };
    } catch (e) {
      print('❌ AuthService Register Error: $e');
      return {
        'success': false,
        'message': 'Kayıt işlemi sırasında bir hata oluştu: $e'
      };
    }
  }

  // Mock token oluştur
  static String _generateMockToken(dynamic userId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    // Gerçek JWT formatına benzer bir token oluştur
    final header = base64.encode(utf8.encode('{"alg":"HS256","typ":"JWT"}'));
    final payload =
        base64.encode(utf8.encode('{"userId":"$userId","exp":$timestamp}'));
    final signature = base64.encode(utf8.encode('mock_signature_$userId'));

    return '$header.$payload.$signature';
  }

  // Token doğrulama (Mock)
  static Future<bool> validateToken(String token) async {
    // Mock için basit kontrol
    return token.contains('.') && token.split('.').length == 3;
  }

  // Şifre sıfırlama (Mock)
  static Future<Map<String, dynamic>> resetPassword(String email) async {
    await Future.delayed(const Duration(milliseconds: 800));

    try {
      // E-posta var mı kontrol et
      final userData = await MockApiService.loginUser(email, 'dummy_password');
      // Bu işlem başarısız olacak ama 404 vs almayacağız, sadece null dönecek

      // E-posta sistemde kayıtlı mı kontrol etmek için farklı bir yaklaşım
      // Şimdilik basit bir mock response döndürüyoruz
      return {
        'success': true,
        'message': 'Şifre sıfırlama bağlantısı e-posta adresinize gönderildi.'
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'E-posta doğrulama sırasında hata oluştu.'
      };
    }
  }

  // E-posta doğrulama (Mock)
  static Future<bool> verifyEmail(String code) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock için basit kontrol
    return code.length == 6;
  }

  // Kullanıcı profili güncelleme - INT userId (değişiklik yok)
  static Future<Map<String, dynamic>> updateProfile(
      int userId, TabloUyeler updatedUser) async {
    try {
      print('🔄 AuthService: Profil güncelleniyor - User ID: $userId');

      // Mock API Server'da kullanıcı bilgilerini güncelle
      final userData = updatedUser.toJson();
      final result = await MockApiService.updateUser(userId, userData);

      final user = TabloUyeler.fromJson(result);

      return {
        'success': true,
        'user': user,
        'message': 'Profil başarıyla güncellendi!'
      };
    } catch (e) {
      print('❌ AuthService Update Error: $e');
      return {
        'success': false,
        'message': 'Profil güncellenirken hata oluştu: $e'
      };
    }
  }
}

// TabloUyeler için toJson extension
extension TabloUyelerJson on TabloUyeler {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fbid': fbid,
      'hesap': hesap,
      'vergi': vergi,
      'ad': ad,
      'soyad': soyad,
      'email': email,
      'telefon': telefon,
      'sifre': sifre,
      'resim': resim,
      'il': il,
      'ilce': ilce,
      'adres': adres,
      'tc': tc,
      'firmaadi': firmaadi,
      'vergino': vergino,
      'vergidairesi': vergidairesi,
      'firma_tel': firma_tel,
      'firma_adres': firma_adres,
      'kampanya_eposta': kampanya_eposta,
      'kampanya_sms': kampanya_sms,
      'indirim': indirim,
      'statu': statu,
      'durum': durum,
      'ceponay': ceponay,
      'cepkod': cepkod,
      'emailonay': emailonay,
      'emailkod': emailkod,
      'son_giris': son_giris,
      'tarih': tarih,
      'ay': ay,
      'ktarih': ktarih,
      'parasutuyeid': parasutuyeid,
      'vatandas': vatandas,
      'vip': vip,
      'mnot': mnot,
      'ip': ip,
    };
  }
}
