// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_ofisi_mobile/widgets/product_card_v2.dart';
import '../providers/product_provider.dart';
import '../widgets/flash_card_widget.dart';
import '../widgets/product_lists_widgets/loading_widget.dart';
import '../widgets/product_lists_widgets/error_widget.dart';
import 'product_list_screen.dart'; // ProductListScreen'i import ettik

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Ürünleri yükle, böylece öne çıkan ürünleri gösterebiliriz
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        // Çentik ve durum çubuğu alanlarını hesaba kat
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24), // Üst boşluk

              // Başlık
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Web Ofisi',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[750],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Dijital Çözümleriniz Burada Başlar',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Flash Kartlar Bölümü
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Öne Çıkan Hizmetler',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 180, // Flash kartların yüksekliği
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  children: [
                    FlashCardWidget(
                      title: 'Güvenli Hazır Site Çözümleri',
                      description:
                          'Gizliliğiniz ve güvenliğiniz bizim için çok önemlidir. Ucuz web sitesi hizmetlerimizle güvenilir ve kaliteli hizmet sunuyoruz.',
                      backgroundColor: Colors.blue[600]!,
                      icon: Icons.web,
                    ),
                    FlashCardWidget(
                      title: 'Profesyonel Hazır Web Sitesi Ekibi',
                      description:
                          'Deneyimli ve yetenekli ekibimiz, hazır site projelerinizde sizlere yardımcı olmak için çalışmaktadır.',
                      backgroundColor: Colors.green[600]!,
                      icon: Icons.shopping_cart,
                    ),
                    FlashCardWidget(
                      title: 'Ekonomik Web Sitesi ve Memnuniyet',
                      description:
                          'Ucuz web sitesi paketlerimizle müşteri memnuniyetini ön planda tutarak, binlerce mutlu müşteriye ulaştık.',
                      backgroundColor: Colors.orange[600]!,
                      icon: Icons.trending_up,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Öne Çıkan Ürünler Bölümü
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Popüler Ürünlerimiz',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Consumer<ProductProvider>(
                builder: (context, productProvider, child) {
                  if (productProvider.isLoading) {
                    return Padding(
                      padding: EdgeInsets.all(24.0),
                      child: LoadingWidget(),
                    );
                  } else if (productProvider.errorMessage.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Error1Widget(
                        message: productProvider.errorMessage,
                        onRetry: () => productProvider.loadProducts(),
                      ),
                    );
                  } else if (productProvider.allProducts.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Center(
                        child: Text(
                          'Gösterilecek ürün bulunamadı.',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                    );
                  } else {
                    // İlk 5 ürünü göster (örnek olarak)
                    final featuredProducts =
                        productProvider.allProducts.take(5).toList();

                    return SizedBox(
                      height:
                          300, // Ürün kartlarının yüksekliğine göre ayarlandı
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal, // Yatay kaydırma
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        itemCount: featuredProducts.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                right: 16.0), // Kartlar arası boşluk
                            child: SizedBox(
                              width: 320,
                              child: ProductCardV2(
                                  product: featuredProducts[index]),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 24),

              // Tümünü Göster Butonu
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductListScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      'Tüm Ürünleri Göster',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30), // Alt boşluk
            ],
          ),
        ),
      ),
    );
  }
}
