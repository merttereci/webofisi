// lib/models/register_form_data.dart
class RegisterFormData {
  // Step 1: Hesap Tipi
  bool isCompany = false;

  // Step 2: Kişisel Bilgiler
  String ad = '';
  String soyad = '';

  // Step 3: Fatura Bilgileri
  String il = '';
  String ilce = '';
  String adres = '';
  String tc = '';
  bool tcVatandasi = true; // "TC vatandaşı değilim" checkbox için

  // Kurumsal-specific fields
  String firmaadi = '';
  String vergino = '';
  String vergidairesi = '';

  // Step 4: Üyelik Bilgileri
  String email = '';
  String telefon = '';
  String sifre = '';
  String sifreTekrar = '';

  // Step 5: Sözleşmeler & Tercihler
  bool sozlesmeKabul = false; // Zorunlu
  bool emailKampanya = false; // kampanya_eposta
  bool smsKampanya = false; // kampanya_sms
  bool pushBildirim = false; // Gelecekte kullanım için

  RegisterFormData();

  // Validation helper'lar
  bool isStep1Valid() {
    return true; // Sadece seçim yapması yeterli
  }

  bool isStep2Valid() {
    return ad.trim().isNotEmpty && soyad.trim().isNotEmpty;
  }

  bool isStep3Valid() {
    // Temel alanlar
    final basicValid =
        il.isNotEmpty && ilce.isNotEmpty && adres.trim().isNotEmpty;

    if (isCompany) {
      // Kurumsal için firma bilgileri de gerekli
      return basicValid &&
          firmaadi.trim().isNotEmpty &&
          vergino.trim().isNotEmpty &&
          vergidairesi.trim().isNotEmpty;
    } else {
      // Bireysel için TC kontrolü (eğer TC vatandaşıysa)
      if (tcVatandasi) {
        return basicValid && tc.length == 11;
      } else {
        return basicValid; // TC vatandaşı değilse TC gerekli değil
      }
    }
  }

  bool isStep4Valid() {
    return email.contains('@') &&
        email.trim().isNotEmpty &&
        telefon.trim().isNotEmpty &&
        sifre.length >= 6 &&
        sifre == sifreTekrar;
  }

  bool isStep5Valid() {
    return sozlesmeKabul; // Sadece sözleşme kabul zorunlu
  }

  // TabloUyeler'e dönüştürme
  Map<String, dynamic> toTabloUyelerData() {
    return {
      // ID Mock API Server tarafından atanacak
      'fbid': 0,
      'hesap': 1, // Bu alanın tam anlamını bilmiyoruz
      'vergi': 1, // Vergi mükellefi mi?
      'ad': ad,
      'soyad': soyad,
      'email': email,
      'telefon': telefon,
      'sifre': sifre,
      'resim': '',
      'il': il,
      'ilce': ilce,
      'adres': adres,
      'tc': tcVatandasi ? tc : '', // TC vatandaşı değilse boş
      'firmaadi': isCompany ? firmaadi : '',
      'vergino': isCompany ? vergino : '',
      'vergidairesi': isCompany ? vergidairesi : '',
      'firma_tel': '',
      'firma_adres': '',
      'kampanya_eposta': emailKampanya ? 1 : 0, // Checkbox değerini aktar
      'kampanya_sms': smsKampanya ? 1 : 0, // Checkbox değerini aktar
      'indirim': '',
      'statu': 0,
      'durum': 0,
      'ceponay': 0,
      'cepkod': '',
      'emailonay': 0,
      'emailkod': '',
      'son_giris': '',
      'tarih': DateTime.now().toString(),
      'ay': DateTime.now().month.toString().padLeft(2, '0'),
      'ktarih': DateTime.now().toString().split(' ')[0],
      'parasutuyeid': 0,
      'vatandas': tcVatandasi ? 1 : 0,
      'vip': 0,
      'mnot': '',
      'ip': '127.0.0.1',
    };
  }

  // Debug için
  @override
  String toString() {
    return 'RegisterFormData{isCompany: $isCompany, ad: $ad, soyad: $soyad, email: $email}';
  }

  // Reset form
  void clear() {
    isCompany = false;
    ad = '';
    soyad = '';
    il = '';
    ilce = '';
    adres = '';
    tc = '';
    tcVatandasi = true;
    firmaadi = '';
    vergino = '';
    vergidairesi = '';
    email = '';
    telefon = '';
    sifre = '';
    sifreTekrar = '';
    sozlesmeKabul = false;
    emailKampanya = false;
    smsKampanya = false;
    pushBildirim = false;
  }
}
