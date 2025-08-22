import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../screens/product_detail_screen.dart';
import '../../providers/cart_provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

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
              padding: EdgeInsets.all(14), // 16'dan 14'e düşürüldü
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductImage(),
                  SizedBox(width: 14), // 16'dan 14'e düşürüldü
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(10), // 12'den 10'a düşürüldü
      child: Container(
        width: 70, // 80'den 70'e düşürüldü
        height: 70, // 80'den 70'e düşürüldü
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
                      size: 28, // 32'den 28'e düşürüldü
                    ),
                  );
                },
              )
            : Center(
                child: Icon(
                  Icons.web,
                  color: Colors.grey[400],
                  size: 28, // 32'den 28'e düşürüldü
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

        SizedBox(height: 6), // 8'den 6'ya düşürüldü

        // Kodlama
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: 6, vertical: 3), // Padding küçültüldü
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(5), // 6'dan 5'e düşürüldü
          ),
          child: Text(
            product.coding,
            style: TextStyle(
              fontSize: 11, // 12'den 11'e düşürüldü
              color: Colors.blue[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        SizedBox(height: 6), // 8'den 6'ya düşürüldü

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

        SizedBox(height: 10), // 12'den 10'a düşürüldü

        // Fiyat ve Sepet Butonu
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Fiyat (Sol)
            Text(
              '${product.price.toStringAsFixed(0)} ${product.priceUnit}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green[600],
              ),
            ),

            // Sepet Butonu (Sağ) - Daha şık ve küçük
            Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                final isInCart = cartProvider.isInCart(product.id);

                return GestureDetector(
                  onTap: () {
                    cartProvider.toggleCart(product.id);
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isInCart ? Colors.green[600] : Colors.blue[600],
                      borderRadius: BorderRadius.circular(16),
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
    );
  }
}
