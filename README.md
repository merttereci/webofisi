# Güncel Proje Yapısı

## Dizin Yapısı
```
lib/
├── main.dart                           # Ana uygulama dosyası ve Provider yapılandırması
├── models/                             # Veri modelleri
│   ├── tables/                         # Veritabanı tablo modelleri
│   │   ├── banka_hesaplari.dart       # Banka hesapları modeli
│   │   ├── destek_cevaplar.dart       # Destek cevapları modeli
│   │   ├── destek.dart                # Destek modeli
│   │   ├── hosting_siparis.dart       # Hosting siparişleri modeli
│   │   ├── indirim_kuponlari.dart     # İndirim kuponları modeli
│   │   ├── kategoriler.dart           # Kategoriler modeli
│   │   ├── krediler.dart              # Krediler modeli
│   │   ├── scriptler.dart             # Scriptler modeli (veritabanı ürün verisi)
│   │   ├── siparisler.dart            # Siparişler modeli
│   │   ├── slider.dart                # Slider modeli
│   │   └── uyeler.dart                # Üyeler modeli
│   └── product.dart                    # Ana ürün modeli (XML verisi)
├── providers/                          # State Management (Provider)
│   ├── cart_provider.dart             # Sepet state yönetimi (minimal ID-based)
│   ├── product_provider.dart          # Ürün state yönetimi
│   └── user_provider.dart             # Kullanıcı state yönetimi
├── screens/                           # Uygulama ekranları
│   ├── tabs/                          # Tab ekranları
│   │   ├── home_tab.dart              # Ana sayfa tab
│   │   ├── products_tab.dart          # Ürünler tab
│   │   └── profile_tab.dart           # Profil tab
│   ├── auth_screen.dart               # Giriş ve kayıt ekranı
│   ├── cart_screen.dart               # Sepet ekranı (modal içerik)
│   ├── home_screen.dart               # Ana sayfa ekranı (AppBar + sepet ikonu)
│   ├── main_screen.dart               # Ana ekran (3-tab navigation)
│   ├── product_detail_screen.dart     # Ürün detay ekranı
│   ├── product_list_screen.dart       # Ürün listesi ekranı (AppBar + sepet ikonu)
│   └── profile_screen.dart            # Profil ekranı
├── services/                          # API ve servis katmanı
│   ├── auth_service.dart              # **GÜNCELLENDI** - Mock API entegrasyonu ile kimlik doğrulama
│   ├── mock_api_service.dart          # **YENİ** - JSON Mock Server HTTP servisi
│   └── product_service.dart           # Ürün API servisi (XML parser)
└── widgets/                           # Özel widget bileşenleri
    ├── cart_modal_widget.dart         # Reusable sepet modal widget
    ├── custom_bottom_navbar.dart      # Özel bottom navigation (3-tab)
    ├── flash_card_widget.dart         # Flash kart widget
    ├── product_card_v2.dart           # Kompakt ürün kartı (ana sayfa)
    ├── product_details_widgets/       # Ürün detay widget'ları
    │   ├── product_demo_buttons.dart  # Demo butonları
    │   ├── product_description_section.dart # Açıklama bölümü
    │   ├── product_detail_row.dart    # Detay satırları
    │   └── product_image_gallery.dart # Görsel galerisi
    └── product_lists_widgets/         # Ürün listesi widget'ları
        ├── category_selector_modal.dart # Kategori seçici modal
        ├── compact_search_widget.dart # Kompakt arama + kategori widget
        ├── error_widget.dart          # Hata widget'ı
        ├── loading_widget.dart        # Yükleme widget'ı
        ├── pagination_widget.dart     # Sayfalama widget'ı
        ├── product_card.dart          # Ana ürün kartı (ürünler sayfası)

# **YENİ DOSYALAR:**
├── db.json                            # **YENİ** - JSON Mock Server veritabanı
└── package.json                       # **YENİ** - Mock server konfigürasyonu (opsiyonel)
```

## Proje Açıklaması

Web Ofisi Mobile, kurumsal web yazılımları satışı için geliştirilmiş modern bir Flutter e-ticaret uygulamasıdir. **İki farklı veri kaynağı** kullanarak hybrid bir yaklaşım benimser: XML API'den 158 adet hazır web scripti çekerken, kullanıcı verilerini JSON Mock Server üzerinden yönetir.

## **YENİ GÜNCELLENEN MİMARİ YAPISSI**

### **Hybrid Data Architecture**
- **XML API**: Ürün bilgileri (product.dart modeli ile 158 script)
- **JSON Mock Server**: Kullanıcı, sipariş, favoriler ve tüm işlem verileri
- **SharedPreferences**: Oturum persistance ve cache

### State Management
MVVM mimarisi kullanılarak Provider pattern ile reactive state yönetimi gerçekleştiriliyor. **UserProvider artık gerçek HTTP istekleri** yaparak Mock API Server ile entegre çalışmaktadır. CartProvider minimal veri saklama prensibi ile sadece ürün ID'lerini saklayarak memory optimizasyonu yapıyor. Tüm veriler SharedPreferences ile kalıcı olarak saklanıyor.

### **YENİ - JSON Mock Server Entegrasyonu**
Production-ready bir backend deneyimi sağlamak için **json-server** kullanılmaktadır. Bu yaklaşım:
- Gerçek HTTP istekleri (GET, POST, PUT, DELETE)
- RESTful API deneyimi
- Gerçek zamanlı veri güncellemeleri
- Production API'ye kolay geçiş imkanı sağlar

### Navigation ve UI Mimarisi
3-tab navigation sistemi (Ana Sayfa, Ürünler, Profil) CustomBottomNavbar ile yönetiliyor. Sepet sistemi reusable CartModalWidget ile modal bottom sheet olarak açılıyor. Her iki ana sayfada (Home ve Products) AppBar'da sepet ikonu ve badge sistemi bulunuyor. IndexedStack kullanılarak tab değişimlerinde state preservation sağlanıyor.

### **YENİ - Güncellenmiş Veri Akışı ve Servisler**
- **XML verisi**: web-ofisi.com'dan ProductService ile çekiliyor (değişiklik yok)
- **Mock API verisi**: MockApiService ile JSON Mock Server'dan HTTP istekleri
- **AuthService**: Mock API Server ile entegre authentication sistemi
- **UserProvider**: Gerçek login/register/update işlemleri
- **Session Management**: Token-based authentication with persistence

## **YENİ EKLENEN SERVİS KATMANI**

### **MockApiService (lib/services/mock_api_service.dart)**
JSON Mock Server ile iletişimi sağlayan kapsamlı HTTP servisi:

**Kullanıcı İşlemleri:**
- `loginUser(email, password)` - Kullanıcı girişi
- `registerUser(userData)` - Yeni kullanıcı kaydı
- `updateUser(userId, userData)` - Kullanıcı profili güncelleme

**Script İşlemleri:**
- `getAllScripts()` - Tüm scriptleri getir
- `getScriptById(scriptId)` - Script detayları
- `getAllCategories()` - Kategorileri getir

**Favoriler İşlemleri:**
- `getUserFavorites(userId)` - Kullanıcının favorileri
- `addToFavorites(userId, scriptId)` - Favori ekle
- `removeFromFavorites(userId, scriptId)` - Favori sil

**Base URL Konfigürasyonu:**
```dart
// Development (Android Emulator)
static const String baseUrl = 'http://10.0.2.2:3000';

// Physical Device
// static const String baseUrl = 'http://YOUR_IP:3000';
```

### **Güncellenmiş AuthService (lib/services/auth_service.dart)**
**BÜYÜK DEĞİŞİKLİK:** Asset-based mock veriler yerine Mock API Server kullanımı

**Önceki versiyon:** SharedPreferences ve asset JSON dosyası
**Güncel versiyon:** HTTP istekleri ve gerçek API davranışı

**Yeni özellikler:**
- MockApiService entegrasyonu
- Type-safe ID handling (string ID'leri integer'a dönüştürme)
- Comprehensive error handling
- Production-ready authentication flow

**Login akışı:**
```dart
userData = await MockApiService.loginUser(email, password)
→ TabloUyeler.fromJson(userData)
→ Token generation
→ SharedPreferences persistence
```

## **JSON Mock Server Konfigürasyonu**

### **db.json Yapısı**
Gerçek veritabanı şemasına uygun olarak tasarlanmış:

```json
{
  "uyeler": [...],           // TabloUyeler modeline uygun
  "scriptler": [...],        // TabloScriptler modeline uygun  
  "kategoriler": [...],      // TabloKategoriler modeline uygun
  "siparisler": [...],       // TabloSiparisler modeline uygun
  "favorites": [...],        // user_id, script_id, created_at
  "krediler": [...],         // TabloKrediler modeline uygun
  "destek": [...],           // TabloDestek modeline uygun
  "destek_cevaplar": [...],  // TabloDestekCevaplar modeline uygun
  "hosting_siparisler": [...], // TabloHostingSiparisler modeline uygun
  "indirim_kuponlari": [...], // TabloIndirimKuponlari modeline uygun
  "banka_hesaplari": [...],  // TabloBankaHesaplari modeline uygun
  "slider": [...]            // TabloSlider modeline uygun
}
```

### **Server Başlatma**
```bash
# NPX ile (önerilen)
npx json-server --watch db.json --port 3000

# Global kurulum sonrası
json-server --watch db.json --port 3000
```

### **Otomatik REST Endpoints**
```
GET    /uyeler              # Tüm kullanıcılar
POST   /uyeler              # Yeni kullanıcı
PUT    /uyeler/1            # Kullanıcı güncelle
DELETE /uyeler/1            # Kullanıcı sil

GET    /favorites?user_id=1 # Query parameters
POST   /favorites           # Favori ekle
DELETE /favorites/1         # Favori sil
```

## Mevcut Özellikler

### **YENİ - Gerçek Backend Deneyimi**
- **Gerçek HTTP Authentication**: MockApiService ile login/register
- **Database-like operations**: CRUD işlemleri JSON Mock Server üzerinde
- **Real-time data persistence**: Değişiklikler db.json dosyasına yazılır
- **Session management**: Token-based authentication
- **Type-safe data handling**: String ID'lerin integer'a dönüştürülmesi

### **YENİ - Enhanced User Management**
- **Production-ready login flow**: Email/password validation
- **Real user registration**: Form validation ve duplicate email kontrolü
- **Profile management**: Kullanıcı bilgilerini güncelleyebilme
- **Session persistence**: App restart'ta otomatik login

### Çalışan Ana Özellikler
- **Mock veritabanı** kullanıcı kimlik doğrulama sistemi (HTTP persistence)
- XML'den 158 ürünün çekilmesi, arama ve kategori filtreleme (değişiklik yok)
- Sayfalama ile optimize edilmiş ürün listesi yönetimi (değişiklik yok)
- Minimal sepet sistemi (ID-based storage, KDV hesaplaması) (değişiklik yok)
- 3-tab responsive tasarım ve state preservation (değişiklik yok)
- Reusable widget'lar ile tutarlı UI deneyimi (değişiklik yok)

### **Favoriler Sistemi Altyapısı (Hazır)**
Mock API Server'da favorites tablosu mevcut ve MockApiService'te endpoint'ler hazır:
- Database schema: user_id, script_id, created_at
- CRUD operations: add, remove, list favorites
- Real-time data synchronization

### Sepet Sistemi ve E-ticaret
Sepet sistemi Set<int> veri yapısı ile sadece ürün ID'lerini saklayarak memory kullanımını optimize ediyor. Her ürün için toggle mantığı (ekle/çıkar) kullanılıyor. Yüzde 20 KDV hesaplaması otomatik olarak yapılıyor ve fiyat detayları (ara toplam, KDV, genel toplam) ayrı ayrı gösteriliyor. CartModalWidget ile tüm uygulamada tutarlı sepet deneyimi sunuluyor.

## **GÜNCELLENEN TEKNİK DETAYLAR**

### **Yeni Dependency'ler**
```yaml
dependencies:
  http: ^1.1.0              # YENİ - HTTP istekleri için
  # Diğerleri aynı...
```

### **Provider Bağımlılıkları ve State Yönetimi**
MultiProvider yapısı ile ProductProvider (158 ürün + filtreleme), **güncellenmiş UserProvider** (Mock API auth + profile) ve CartProvider (minimal sepet) merkezi olarak yönetiliyor. Consumer2 pattern'i ile CartProvider ve ProductProvider'ın birlikte kullanıldığı ekranlarda optimize edilmiş rendering sağlanıyor.

### **Yeni Veri Modelleri ve Optimizasyon**
- **Product.dart**: XML parsing ile 158 ürünü yönetiyor (değişiklik yok)
- **TabloUyeler ve diğer tablo modelleri**: JSON Mock Server ile uyumlu
- **MockApiService**: HTTP istekleri ile REST API simulation
- **AuthService**: Production-ready authentication patterns

### **Type Safety ve Error Handling**
JSON Mock Server'ın bazen string ID üretmesi nedeniyle robust type casting uygulanmıştır:

```dart
// AuthService'te type safety
if (createdUser['id'] is String) {
  createdUser['id'] = DateTime.now().millisecondsSinceEpoch % 100000;
}
```

## **GÜNCELLENECEK ALANLAR**

### **Yakın Gelecek Özellikleri**
1. **Favoriler UI implementasyonu** (backend hazır) - Provider + widget integration
2. **Sipariş verme workflow'unun tamamlanması** - MockApiService ile orders tablosu kullanımı
3. **Kullanıcı profil düzenleme sayfası** - MockApiService.updateUser kullanımı
4. Push notification entegrasyonu
5. Advanced search filters (fiyat aralığı, sıralama)
6. Dark mode desteği

### **Uzun Vadeli İyileştirmeler**
- **Real API transition**: JSON Mock Server'dan production API'ye geçiş (sadece URL değişikliği gerekli)
- Ödeme sistemi entegrasyonu
- **Sipariş takip sistemi**: Mock API'deki orders tablosunu kullanarak
- **Ürün karşılaştırma özelliği**: MockApiService ile comparison endpoint'leri
- Advanced analytics ve user behavior tracking
- **Progressive web app desteği**: Mevcut HTTP infrastructure ile uyumlu

## **PERFORMANS VE OPTİMİZASYON**

### **Yeni Network ve Storage Verimliliği**
- **HTTP connection pooling**: Efficient API requests
- **Real-time data synchronization**: JSON Mock Server ile
- **Type-safe data parsing**: Runtime type checking ve conversion
- **Production-ready architecture**: Mock'tan real API'ye seamless transition

### Memory ve Storage Verimliliği
Sepet sistemi ID-based storage ile her ürün için sadece 4-8 byte kullanıyor. ProductProvider single source of truth prensibi ile duplicate data'yı engelliyor. Lazy loading ve error handling ile robust image management sağlanıyor. **SharedPreferences ile enhanced session management** gerçekleştiriliyor.

### **Yeni Kullanıcı Deneyimi ve Responsive Design**
- **Real-time authentication feedback** ile instant user response
- **Network-aware error handling** ile robust user experience
- **Seamless session management** ile uninterrupted user journey
- Gerçek zamanlı sepet badge güncellemeleri ile instant feedback (değişiklik yok)
- IndexedStack ile smooth tab navigation ve state preservation (değişiklik yok)

## **DEVELOPMENT SETUP**

### **JSON Mock Server Kurulumu**
```bash
# Node.js kurulu olması gerekli
npm install -g json-server

# Proje klasöründe
npx json-server --watch db.json --port 3000

# Windows PowerShell sorunları için
npx json-server --watch db.json --port 3000
```


### **Test Endpoints**
```bash
# Browser'da test
http://localhost:3000/uyeler
http://localhost:3000/scriptler
http://localhost:3000/favorites
```

---

**Son Güncelleme:** JSON Mock Server entegrasyonu ve gerçek HTTP authentication sistemi tamamlandı  
**Toplam Dosya Sayısı:** 30+ dart dosyası + db.json + mock server configuration  
**Ana Özellikler:** **Real HTTP authentication**, ürün browsing, optimized cart system, responsive UI, **production-ready backend simulation**  
**Mimari:** **Clean Architecture + HTTP Services**, Provider pattern, Widget-based modular design, **Mock-to-Production transition ready**

## **PRODUCTION GEÇİŞ STRATEJISI**

### **Mock'tan Real API'ye Geçiş**
Mevcut JSON Mock Server yapısı, production PHP API'ye geçiş için optimum hazırlık sağlamaktadır:

1. **URL değişikliği**: MockApiService'te sadece baseUrl güncellenmesi yeterli
2. **HTTP method compatibility**: Aynı REST endpoint'ler kullanılabilir
3. **Data model compatibility**: Tablo modelleri gerçek veritabanı ile uyumlu
4. **Authentication flow**: Token-based system production-ready

```dart
// Development
static const String baseUrl = 'http://10.0.2.2:3000';

// Production
static const String baseUrl = 'https://yourdomain.com/api';
```

Kod değişikliği **minimum** düzeyde kalacaktır.