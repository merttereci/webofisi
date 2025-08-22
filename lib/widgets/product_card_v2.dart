// lib/widgets/product_card_v2.dart (Basitleştirilmiş - Miktar Yok)
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class ProductCardV2 extends StatelessWidget {
  final Product product;

  const ProductCardV2({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> categories = product.category;
    final String categoryText =
        categories.isNotEmpty ? categories.take(2).join(', ') : 'Genel';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 16.0, bottom: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ürün Görseli
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  product.image.isNotEmpty
                      ? product.image
                      : 'https://via.placeholder.com/300x170?text=Görsel+Yok',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: Icon(Icons.broken_image,
                        color: Colors.grey[400], size: 50),
                  ),
                ),
              ),
            ),

            // Ürün Bilgileri
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ürün adı ve kategori
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[850],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            categoryText,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Fiyat ve Sepete Ekle
                    Row(
                      children: [
                        // Fiyat (Sol)
                        Expanded(
                          child: Text(
                            '${product.price.toStringAsFixed(0)} ${product.priceUnit}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                        ),

                        // Sepete Ekle Butonu (Sağ)
                        Consumer<CartProvider>(
                          builder: (context, cartProvider, child) {
                            final isInCart = cartProvider.isInCart(product.id);

                            return GestureDetector(
                              onTap: () => cartProvider.toggleCart(product.id),
                              child: Container(
                                width: isInCart ? 32 : 32,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: isInCart
                                      ? Colors.green[600]
                                      : Colors.blue[600],
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: isInCart
                                    ? Icon(
                                        Icons.check,
                                        size: 14,
                                        color: Colors.white,
                                      )
                                    : Icon(
                                        Icons.shopping_cart,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
