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
│   ├── auth_service.dart              # Kimlik doğrulama servisi (mock)
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
        
```
## Proje Açıklaması

Web Ofisi Mobile, kurumsal web yazılımları satışı için geliştirilmiş modern bir Flutter e-ticaret uygulamasıdır. XML API'den 158 adet hazır web scripti çekerek kullanıcılara sunan, minimal sepet sistemi ve KDV hesaplaması içeren responsive bir mobil platform sağlar.


## Mimari Yapı

### State Management
MVVM mimarisi kullanılarak Provider pattern ile reactive state yönetimi gerçekleştiriliyor. Consumer ve Consumer2 pattern'leri ile UI güncellemeleri otomatik olarak sağlanıyor. CartProvider minimal veri saklama prensibi ile sadece ürün ID'lerini saklayarak memory optimizasyonu yapıyor. Tüm veriler SharedPreferences ile kalıcı olarak saklanıyor.

### Navigation ve UI Mimarisi
3-tab navigation sistemi (Ana Sayfa, Ürünler, Profil) CustomBottomNavbar ile yönetiliyor. Sepet sistemi reusable CartModalWidget ile modal bottom sheet olarak açılıyor. Her iki ana sayfada (Home ve Products) AppBar'da sepet ikonu ve badge sistemi bulunuyor. IndexedStack kullanılarak tab değişimlerinde state preservation sağlanıyor.

### Veri Akışı ve Servisler
XML verisi web-ofisi.com'dan ProductService ile çekiliyor ve ProductProvider'da saklanıyor. Kompakt arama sistemi CompactSearchWidget ile tek satırda arama ve kategori seçimi yapılıyor. Kullanıcı etkileşimleri CartProvider'da yönetiliyor ve gerçek zamanlı UI güncellemeleri sağlanıyor.

## Mevcut Özellikler

### Çalışan Ana Özellikler
- Mock kullanıcı kimlik doğrulama sistemi (SharedPreferences persistence)
- XML'den 158 ürünün çekilmesi, arama ve kategori filtreleme
- Sayfalama ile optimize edilmiş ürün listesi yönetimi
- Minimal sepet sistemi (ID-based storage, KDV hesaplaması)
- 3-tab responsive tasarım ve state preservation
- Reusable widget'lar ile tutarlı UI deneyimi

### Sepet Sistemi ve E-ticaret
Sepet sistemi Set<int> veri yapısı ile sadece ürün ID'lerini saklayarak memory kullanımını optimize ediyor. Her ürün için toggle mantığı (ekle/çıkar) kullanılıyor. Yüzde 20 KDV hesaplaması otomatik olarak yapılıyor ve fiyat detayları (ara toplam, KDV, genel toplam) ayrı ayrı gösteriliyor. CartModalWidget ile tüm uygulamada tutarlı sepet deneyimi sunuluyor.

### Kullanıcı Arayüzü ve Widget Mimarisi
Material Design 3 standartları ile modern tasarım oluşturuldu. CompactSearchWidget ile space-efficient arama sistemi, ProductCard ve ProductCardV2 varyantları ile farklı sayfalara özel kart tasarımları kullanılıyor. FlashCard widget'ları ile promotional content gösterimi, gradient tasarımlar ve subtle shadow'lar ile premium görünüm sağlanıyor.

## Teknik Detaylar

### Provider Bağımlılıkları ve State Yönetimi
MultiProvider yapısı ile ProductProvider (158 ürün + filtreleme), UserProvider (mock auth + profile) ve CartProvider (minimal sepet) merkezi olarak yönetiliyor. Consumer2 pattern'i ile CartProvider ve ProductProvider'ın birlikte kullanıldığı ekranlarda optimize edilmiş rendering sağlanıyor.

### Veri Modelleri ve Optimizasyon
Product.dart modeli XML parsing ile 158 ürünü yönetiyor. CartProvider Set<int> ile minimal sepet verisi saklıyor (ortalama 12 byte per item). UserProvider SharedPreferences ile oturum persistance sağlıyor. Lazy loading ile görseller optimize edilmiş şekilde yükleniyor.

### Widget Hiyerarşisi ve Modüler Tasarım
AuthWrapper → MainScreen → CustomBottomNavbar → IndexedStack hiyerarşisi kullanılıyor. Reusable widget'lar (CartModalWidget, CompactSearchWidget) ile code duplication engelleniyor. ProductCard varyantları farklı sayfalara özel optimize edilmiş tasarımlar sunuyor.

## Geliştirilecek Alanlar

### Yakın Gelecek Özellikleri
1. Favoriler sistemi eklenmesi (ürün model'ine favorite field'ı)
2. Sipariş verme workflow'unun tamamlanması
3. Kullanıcı profil düzenleme sayfası
4. Push notification entegrasyonu
5. Advanced search filters (fiyat aralığı, sıralama)
6. Dark mode desteği

### Uzun Vadeli İyileştirmeler
Real-time API entegrasyonu (XML'den REST API'ye geçiş), ödeme sistemi entegrasyonu, sipariş takip sistemi, ürün karşılaştırma özelliği, advanced analytics ve user behavior tracking, offline-first architecture ile progressive web app desteği.

## Performans ve Optimizasyon

### Memory ve Storage Verimliliği
Sepet sistemi ID-based storage ile her ürün için sadece 4-8 byte kullanıyor. ProductProvider single source of truth prensibi ile duplicate data'yı engelliyor. Lazy loading ve error handling ile robust image management sağlanıyor. SharedPreferences ile efficient data persistence gerçekleştiriliyor.

### Kullanıcı Deneyimi ve Responsive Design
Gerçek zamanlı sepet badge güncellemeleri ile instant feedback, IndexedStack ile smooth tab navigation ve state preservation, CompactSearchWidget ile space-efficient arama deneyimi, graceful error handling ve fallback UI'lar ile robust user experience sağlanıyor.

---

**Son Güncelleme:** Kompakt arama sistemi ve reusable sepet modal'ı tamamlandı  
**Toplam Dosya Sayısı:** 27+ dart dosyası  
**Ana Özellikler:** Authentication, ürün browsing, optimized cart system, responsive UI  
**Mimari:** Clean Architecture, Provider pattern, Widget-based modular design