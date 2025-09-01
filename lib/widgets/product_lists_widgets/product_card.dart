import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../screens/product_detail_screen.dart';
import '../../providers/cart_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/user_provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  // Favori toggle fonksiyonu
  void _toggleFavorite(BuildContext context) async {
    final userProvider = context.read<UserProvider>();
    final favoritesProvider = context.read<FavoritesProvider>();

    // Kullanıcı giriş yapmış mı kontrol et
    if (!userProvider.isLoggedIn || userProvider.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Favorilere eklemek için giriş yapmalısınız'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Favori toggle işlemi
    final success = await favoritesProvider.toggleFavorite(
      userProvider.currentUser!.id,
      product.id,
    );

    if (success) {
      final isFavorite = favoritesProvider.isFavorite(product.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isFavorite
                ? '${product.name} favorilere eklendi'
                : '${product.name} favorilerden çıkarıldı',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          backgroundColor: isFavorite ? Colors.red[400] : Colors.green[400],
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Favori güncellenirken hata oluştu'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // Detay sayfasına yönlendirme
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => ProductDetailScreen(product: product),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductImage(),
                  SizedBox(width: 14),
                  Expanded(child: _buildProductInfo()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    // TEMİZ GÖRSEL - Üzerinde hiçbir buton yok
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 70,
        height: 70,
        color: Colors.grey[100],
        child: product.image.isNotEmpty
            ? Image.network(
                product.image,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      strokeWidth: 2,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.grey[400],
                      size: 28,
                    ),
                  );
                },
              )
            : Center(
                child: Icon(
                  Icons.web,
                  color: Colors.grey[400],
                  size: 28,
                ),
              ),
      ),
    );
  }

  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Ürün adı
        Text(
          product.name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
            height: 1.3,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        SizedBox(height: 6),

        // Kodlama
        Container(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            product.coding,
            style: TextStyle(
              fontSize: 11,
              color: Colors.blue[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        SizedBox(height: 6),

        // Kategori(ler)
        Text(
          product.category.isNotEmpty
              ? product.category.join(', ')
              : 'Kategori Yok',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
            height: 1.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        SizedBox(height: 12),

        // YENİ: ÜÇLÜ ALT DÜZEN [Fiyat] [❤️] [🛒]
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. FIYAT (Sol)
            Expanded(
              flex: 2,
              child: Text(
                '${product.price.toStringAsFixed(0)} ${product.priceUnit}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[600],
                ),
              ),
            ),

            SizedBox(width: 8),

            // 2. FAVORİ BUTONU (Orta) - Basit Kalp
            Consumer2<FavoritesProvider, UserProvider>(
              builder: (context, favoritesProvider, userProvider, child) {
                final isFavorite = favoritesProvider.isFavorite(product.id);

                return GestureDetector(
                  onTap: () => _toggleFavorite(context),
                  child: Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey[600],
                      size: 20,
                    ),
                  ),
                );
              },
            ),

            SizedBox(width: 8),

            // 3. SEPET BUTONU (Sağ)
            Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                final isInCart = cartProvider.isInCart(product.id);

                return GestureDetector(
                  onTap: () {
                    cartProvider.toggleCart(product.id);
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isInCart ? Colors.green[600] : Colors.blue[600],
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: (isInCart
                                  ? Colors.green[600]!
                                  : Colors.blue[600]!)
                              .withOpacity(0.3),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      isInCart ? Icons.check : Icons.shopping_cart,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
