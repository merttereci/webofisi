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
│   ├── cart_provider.dart             # Sepet state yönetimi
│   ├── product_provider.dart          # Ürün state yönetimi
│   └── user_provider.dart             # Kullanıcı state yönetimi
├── screens/                           # Uygulama ekranları
│   ├── tabs/                          # Tab ekranları
│   │   ├── cart_tab.dart              # Sepet tab (artık kullanılmıyor)
│   │   ├── home_tab.dart              # Ana sayfa tab
│   │   ├── products_tab.dart          # Ürünler tab
│   │   └── profile_tab.dart           # Profil tab
│   ├── auth_screen.dart               # Giriş ve kayıt ekranı
│   ├── cart_screen.dart               # Sepet ekranı (modal olarak açılır)
│   ├── home_screen.dart               # Ana sayfa ekranı
│   ├── main_screen.dart               # Ana ekran (tab navigation)
│   ├── product_detail_screen.dart     # Ürün detay ekranı
│   ├── product_list_screen.dart       # Ürün listesi ekranı
│   └── profile_screen.dart            # Profil ekranı
├── services/                          # API ve servis katmanı
│   ├── auth_service.dart              # Kimlik doğrulama servisi (mock)
│   └── product_service.dart           # Ürün API servisi (XML parser)
└── widgets/                           # Özel widget bileşenleri
    ├── custom_bottom_navbar.dart      # Özel bottom navigation
    ├── flash_card_widget.dart         # Flash kart widget
    ├── product_card_v2.dart           # Kompakt ürün kartı (ana sayfa için)
    ├── product_details_widgets/       # Ürün detay widget'ları
    │   ├── product_demo_buttons.dart  # Demo butonları
    │   ├── product_description_section.dart # Açıklama bölümü
    │   ├── product_detail_row.dart    # Detay satırları
    │   └── product_image_gallery.dart # Görsel galerisi
    └── product_lists_widgets/         # Ürün listesi widget'ları
        ├── category_selector_modal.dart # Kategori seçici modal
        ├── error_widget.dart          # Hata widget'ı
        ├── loading_widget.dart        # Yükleme widget'ı
        ├── pagination_widget.dart     # Sayfalama widget'ı
        ├── product_card.dart          # Ana ürün kartı (ürünler sayfası için)
        ├── search_bar_widget.dart     # Arama çubuğu widget'ı
        └── total_and_categories_widget.dart # Toplam ve kategori widget'ı
```

## Mimari Yapı

### State Management
Uygulama MVVM mimarisi kullanarak Provider pattern ile state yönetimini gerçekleştiriyor. Consumer ve Consumer2 pattern'leri ile reactive UI güncellemeleri sağlanıyor. Veriler SharedPreferences ile kalıcı olarak saklanıyor.

### Navigation
Uygulama 3 ana tab içeriyor: Ana Sayfa, Ürünler ve Profil. Sepet sistemi modal bottom sheet olarak açılıyor. Ürün detay sayfalarına normal navigation ile geçiş yapılıyor.

### Veri Akışı
XML verisi web-ofisi.com'dan ProductService ile çekiliyor ve ProductProvider'da saklanıyor. Kullanıcı etkileşimleri CartProvider'da yönetiliyor ve SharedPreferences ile kalıcı hale getiriliyor.

## Mevcut Özellikler

### Çalışan Özellikler
- Kullanıcı kimlik doğrulama sistemi (mock verilerle)
- XML'den 158 ürünün çekilmesi ve gösterilmesi
- Ürün arama ve filtreleme sistemi
- Sayfalama ile ürün listesi yönetimi
- Sepet sistemi (ürün ekleme/çıkarma ve KDV hesaplaması)
- 3 tab'lı responsive tasarım
- Kullanıcı oturumu ve sepet verilerinin kalıcı saklanması

### Sepet Sistemi
Sepet sistemi minimal veri saklama prensibi ile çalışıyor. Sadece ürün ID'leri saklanarak memory kullanımı optimize ediliyor. Gerçek zamanlı UI güncellemeleri ile kullanıcı deneyimi artırılıyor. Yüzde 20 KDV hesaplaması otomatik olarak yapılıyor.

### Kullanıcı Arayüzü
Material Design 3 standartları kullanılarak modern bir tasarım oluşturuldu. Özel widget'lar (FlashCard, ProductCard varyantları) ile tutarlı bir görünüm sağlanıyor. Gradient tasarımlar ve subtle shadow'lar ile premium bir his yaratılıyor.

## Teknik Detaylar

### Provider Bağımlılıkları
Ana uygulama MultiProvider kullanarak ProductProvider, UserProvider ve CartProvider'ı yönetiyor. Bu sayede tüm uygulama boyunca state yönetimi merkezi olarak gerçekleştiriliyor.

### Veri Modelleri
Product.dart modeli XML parsing ile 158 ürünü yönetiyor. CartProvider minimal sepet verisi için Set<int> kullanıyor. UserProvider mock authentication ve kullanıcı profil bilgilerini saklıyor.

### Widget Hiyerarşisi
AuthWrapper kullanıcı durumuna göre AuthScreen veya MainScreen'i gösteriyor. MainScreen CustomBottomNavbar ile 3 tab yönetiyor ve IndexedStack ile state preservation sağlıyor.

## Geliştirilecek Alanlar

### Öncelik Sırasına Göre
1. Ürünler sayfasına AppBar sepet ikonu eklenmesi
2. Sipariş verme fonksiyonunun tamamlanması
3. Favoriler sisteminin geliştirilmesi
4. XML'den REST API'ye geçiş
5. Profil düzenleme sayfası
6. Push notification entegrasyonu
7. Dark mode desteği

### UI İyileştirmeleri
Gelişmiş arama filtreleri, ürün karşılaştırma özelliği, favoriler sayfası, sipariş geçmişi ve takibi, ödeme entegrasyonu gibi özellikler planlanıyor.

## Performans

### Memory Verimliliği
Sepet sadece ID'leri saklayarak her ürün için yaklaşık 12 byte kullanıyor. Ürünler tek kaynak (ProductProvider) üzerinden yönetiliyor. Görseller lazy loading ile yükleniyor ve hata durumları düzgün yönetiliyor.

### Kullanıcı Deneyimi
Gerçek zamanlı sepet badge güncellemeleri, IndexedStack ile smooth navigation, SharedPreferences ile offline hazırlık ve hata durumlarında graceful fallback'ler sağlanıyor.

---

**Son Güncelleme:** Sepet sistemi tamamlandı, KDV hesaplaması eklendi  
**Toplam Dosya Sayısı:** Yaklaşık 25 dart dosyası  
**Ana Özellikler:** Authentication, ürün gezinme, sepet sistemi  
**Mimari:** Clean Architecture ve Provider pattern

## Mimari Yapı

- **MVVM (Model-View-ViewModel)** mimarisi
- **Provider** state management çözümü
- **Service katmanı** ile API bağlantıları
- **Widget tabanlı** modüler tasarım
- **Clean Architecture** prensipleri

## Özellikler

-  Kullanıcı kimlik doğrulama
-  Ürün listesi ve detay sayfaları
-  Arama ve filtreleme
-  Sayfalama (Pagination)
-  Responsive tasarım
-  State management
-  API entegrasyonu
