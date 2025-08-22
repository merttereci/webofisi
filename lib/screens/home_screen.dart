// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_ofisi_mobile/providers/cart_provider.dart';
import 'package:web_ofisi_mobile/screens/cart_screen.dart';
import 'package:web_ofisi_mobile/widgets/product_card_v2.dart';
import '../providers/product_provider.dart';
import '../providers/user_provider.dart'; // user provider import eklendi
import '../widgets/flash_card_widget.dart';
import '../widgets/product_lists_widgets/loading_widget.dart';
import '../widgets/product_lists_widgets/error_widget.dart';

class HomeScreen extends StatefulWidget {
  final Function(int)? onTabChange; // callback eklendi

  const HomeScreen({Key? key, this.onTabChange}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // ürünleri yükle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts();
    });
  }

  void _showCartModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // tam ekran olabilir
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85, // ekranın %85'i
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // modal handle (çizgi)
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // başlık
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sepetim',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.shopping_bag, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            const Divider(),

            // sepet içeriği - şimdilik CartScreen'i kullan
            Expanded(
              child: CartScreen(), // mevcut CartScreen widget'ı
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      // yeni minimal appbar - sadece logo
      // home_screen.dart AppBar güncellemesi

      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Container(
          height: 40,
          child: Image.asset(
            'assets/logo/logo.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Text(
                'Web Ofisi',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF667eea),
                ),
              );
            },
          ),
        ),
        // home_screen.dart AppBar actions - TAM VERSİYON

        actions: [
          Container(
            width: 48,
            height: 48,
            child: Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                return IconButton(
                  onPressed: () {
                    _showCartModal(context);
                  },
                  padding: EdgeInsets.zero,
                  icon: SizedBox(
                    width: 24,
                    height: 24,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(
                          Icons.shopping_cart,
                          color: Colors.grey[700],
                          size: 24,
                        ),
                        // Badge - sadece sepet boş değilse göster
                        if (cartProvider.isNotEmpty)
                          Positioned(
                            right: -6,
                            top: -4,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 14,
                                minHeight: 14,
                              ),
                              child: Text(
                                '${cartProvider.itemCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16), // üst boşluk artırıldı

            // hoş geldin bölümü - kullanıcı ismi ile kişiselleştirildi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userProvider.isLoggedIn
                            ? 'Merhaba ${userProvider.currentUser?.ad ?? ""}! '
                            : 'Merhaba!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        userProvider.isLoggedIn
                            ? 'İhtiyacınıza uygun hazır yazılımları keşfedin'
                            : 'Projelerinizi keşfetmeye başlayın!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 16), // flash kartlarla arası

            // öne çıkan hizmetler - başlık iyileştirildi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFF667eea),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Öne Çıkan Hizmetlerimiz',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16), // boşluk artırıldı

            // flash kartlar - yükseklik artırıldı
            SizedBox(
              height: 150, // 200den 150ye indirdim
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                children: [
                  FlashCardWidget(
                    title: 'Güvenli Hazır Site Çözümleri',
                    description:
                        'Gizliliğiniz ve güvenliğiniz bizim için çok önemlidir. Ucuz web sitesi hizmetlerimizle güvenilir ve kaliteli hizmet sunuyoruz.',
                    backgroundColor: Colors.blue[600]!,
                    icon: Icons.security,
                  ),
                  FlashCardWidget(
                    title: 'Profesyonel Geliştirici Ekibi',
                    description:
                        'Deneyimli ve yetenekli ekibimiz, projelerinizde sizlere 7/24 destek sağlamaya hazır.',
                    backgroundColor: Colors.green[600]!,
                    icon: Icons.code,
                  ),
                  FlashCardWidget(
                    title: 'Ekonomik ve Kaliteli Çözümler',
                    description:
                        'Uygun fiyatlı paketlerimizle müşteri memnuniyetini ön planda tutarak, binlerce mutlu müşteriye ulaştık.',
                    backgroundColor: Colors.orange[600]!,
                    icon: Icons.trending_up,
                  ),
                  // yeni 4. kart eklendi
                  FlashCardWidget(
                    title: 'Hızlı Teslimat Garantisi',
                    description:
                        'Projelerinizi zamanında ve kaliteli bir şekilde teslim etme garantisi veriyoruz.',
                    backgroundColor: Colors.purple[600]!,
                    icon: Icons.flash_on,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // popüler ürünler - başlık iyileştirildi ve   "tümünü gör" text butonu - otomatik tab geçiş
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 24,
                        decoration: BoxDecoration(
                          color: const Color(0xFF667eea),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Popüler Ürünlerimiz',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                  // "tümünü gör" text butonu - otomatik tab geçiş
                  TextButton(
                    onPressed: () {
                      // callback ile ürünler tab'ına geç (index 1)
                      if (widget.onTabChange != null) {
                        widget.onTabChange!(1);
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Tümünü Gör',
                          style: TextStyle(
                            color: const Color(0xFF667eea),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: const Color(0xFF667eea),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ürün listesi
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
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Henüz ürün yüklenmedi',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  // ilk 6 ürünü göster (5'ten 6'ya çıktı)
                  final featuredProducts =
                      productProvider.allProducts.take(6).toList();

                  return SizedBox(
                    height: 300,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      itemCount: featuredProducts.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: SizedBox(
                            width: 300, // 320'den 300'e düştü - daha kompakt
                            child:
                                ProductCardV2(product: featuredProducts[index]),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),

            // alt boşluk - floating navbar için
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
