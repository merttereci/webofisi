#  Flutter Mobil Uygulama - Proje Yapısı

## Dizin Yapısı

```
lib/
├── main.dart                           # Ana uygulama dosyası
├── models/                             # Veri modelleri
│   ├── tables/                         # Veritabanı tablo modelleri
│   │   ├── banka_hesaplari.dart       # Banka hesapları modeli
│   │   ├── destek_cevaplar.dart       # Destek cevapları modeli
│   │   ├── destek.dart                # Destek modeli
│   │   ├── hosting_siparis.dart       # Hosting siparişleri modeli
│   │   ├── indirim_kuponlari.dart     # İndirim kuponları modeli
│   │   ├── kategoriler.dart           # Kategoriler modeli
│   │   ├── krediler.dart              # Krediler modeli
│   │   ├── scriptler.dart             # Scriptler modeli
│   │   ├── siparisler.dart            # Siparişler modeli
│   │   ├── slider.dart                # Slider modeli
│   │   └── uyeler.dart                # Üyeler modeli
│   └── product.dart                    # Ana ürün modeli
├── providers/                          # State Management (Provider)
│   ├── product_provider.dart          # Ürün state yönetimi
│   └── user_provider.dart             # Kullanıcı state yönetimi
├── screens/                           # Uygulama ekranları
|   ├── tabs/  
|       ├── cart_tab.dart
|       ├── home_tab.dart
|       ├── products_tab.dart
|       └── profile_tab.dart        
│   ├── auth_screen.dart               # Kimlik doğrulama ekranı
│   ├── home_screen.dart               # Ana sayfa ekranı
│   ├── cart_screen.dart    
│   ├── main_screen.dart     
│   ├── profile_screen.dart
│   ├── product_list_screen.dart       # Ürün listesi ekranı
│   └── product_detail_screen.dart     # Ürün detay ekranı
├── services/                          # API ve servis katmanı
│   ├── auth_service.dart              # Kimlik doğrulama servisi
│   └── product_service.dart           # Ürün API servisi
└── widgets/                           # Özel widget bileşenleri
    ├── flash_card_widget.dart      
    ├── product_card_v2.dart
    ├── product_details_widgets/        # Ürün detay widget'ları
    │   ├── product_demo_buttons.dart  # Demo butonları
    │   ├── product_description_section.dart # Açıklama bölümü
    │   ├── product_detail_row.dart    # Detay satırları
    │   └── product_image_gallery.dart # Görsel galerisi
    └── product_lists_widgets/         # Ürün listesi widget'ları
        ├── error_widget.dart          # Hata widget'ı
        ├── category_selector_modal.dart        
        ├── loading_widget.dart        # Yükleme widget'ı
        ├── pagination_widget.dart     # Sayfalama widget'ı
        ├── product_card.dart          # Ürün kartı
        ├── search_bar_widget.dart     # Arama çubuğu
        ├── total_and_categories_widget.dart # Toplam ve kategori widget'ı
        ├── flash_card_widget.dart     # Flash kart widget'ı
        └── product_card_v2.dart       # Ürün kartı v2
```

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
