// lib/models/support_ticket_form_data.dart
import 'dart:io';

class SupportTicketFormData {
  // Kullanıcı bilgileri (UserProvider'dan gelecek)
  String isim = '';
  String email = '';

  // Form alanları
  String baslik = '';
  String departman = 'Teknik Destek';
  String oncelik = 'Orta';
  String hizmet = 'İlişkili hizmetim yok';
  String mesaj = '';

  // Fotoğraf
  File? selectedImage;

  SupportTicketFormData();

  // Dropdown seçenekleri
  static List<String> get departmanSecenekleri => [
        'Teknik Destek',
        'Üyelik İşlemleri',
        'Ödeme İşlemleri (Muhasebe)',
        'Genel (Diğer)'
      ];

  static List<String> get oncelikSecenekleri => ['Yüksek', 'Orta', 'Düşük'];

  static List<String> get hizmetSecenekleri => [
        'İlişkili hizmetim yok',
        // TODO: Sipariş sistemi hazır olunca buraya gerçek veriler eklenecek
        'E-ticaret Script',
        'Blog Script',
        'Kurumsal Web Script',
        'Hosting Hizmeti'
      ];

  // Form validation
  bool isValid() {
    return baslik.trim().isNotEmpty &&
        mesaj.trim().isNotEmpty &&
        departman.isNotEmpty &&
        oncelik.isNotEmpty;
  }

  // Başlık validasyonu
  String? validateBaslik(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Başlık gereklidir';
    }
    if (value.trim().length < 3) {
      return 'Başlık en az 3 karakter olmalıdır';
    }
    if (value.length > 100) {
      return 'Başlık en fazla 100 karakter olabilir';
    }
    return null;
  }

  // Mesaj validasyonu
  String? validateMesaj(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mesaj gereklidir';
    }
    if (value.trim().length < 10) {
      return 'Mesaj en az 10 karakter olmalıdır';
    }
    return null;
  }

  // TabloDestek formatına çevirme
  Map<String, dynamic> toTabloDestekData(int userId) {
    final now = DateTime.now();
    final tarihString = now.toString();

    return {
      // ID JSON-server tarafından otomatik atanacak
      'uye_id': userId,
      'isim': isim,
      'email': email,
      'baslik': baslik,
      'departman': departman,
      'oncelik': oncelik.toLowerCase(), // db.json'da küçük harf
      'hizmet': hizmet,
      'tarih': tarihString,
      'son_giris': tarihString,
      'son_cevap': '',
      'son_tarih': '',
      'ip': '127.0.0.1', // Mock için
      'durum': 0, // Yeni talep
      'cevap_yazan': 0,
      'kisi': '',
      'mesaj': mesaj,
      'bilgiler': selectedImage != null
          ? 'Fotoğraf eklendi'
          : '', // TODO: Base64 conversion
      'ozet': '',
      'seviye': '',
      'islem_tarih': '',
      'yapim_tarih': now.toIso8601String(),
    };
  }

  // Form temizleme
  void clear() {
    baslik = '';
    departman = 'Teknik Destek';
    oncelik = 'Orta';
    hizmet = 'İlişkili hizmetim yok';
    mesaj = '';
    selectedImage = null;
  }

  @override
  String toString() {
    return 'SupportTicketFormData{baslik: $baslik, departman: $departman, oncelik: $oncelik}';
  }
}
