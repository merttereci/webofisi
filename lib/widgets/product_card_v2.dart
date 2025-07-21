// lib/widgets/compact_product_card.dart
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../screens/product_detail_screen.dart'; // Detay sayfasına gitmek için

class ProductCardV2 extends StatelessWidget {
  final Product product;

  const ProductCardV2({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Product modelindeki category zaten List<String> olduğu için direkt kullanıyoruz
    final List<String> categories = product.category;
    // Kategorileri tek bir string olarak birleştir, ilk 2 taneyi alabiliriz veya hepsini
    final String categoryText = categories.isNotEmpty
        ? categories
            .take(2)
            .join(', ') // İlk iki kategoriyi alıp virgülle birleştir
        : 'Genel'; // Kategori yoksa varsayılan

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
        width: 180, // Kartın genişliği (daha kareye yakın olması için)
        margin: const EdgeInsets.only(
            right: 16.0,
            bottom: 8.0), // Sağda boşluk ve altta hafif gölge boşluğu
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12, // Daha yumuşak ve belirgin gölge
              offset: const Offset(
                  0, 6), // Gölgenin konumunu aşağıya doğru ayarladık
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ürün Görseli - Daha büyük ve daha iyi bir oran
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: AspectRatio(
                // Görselin en boy oranını korumak için AspectRatio kullandık
                aspectRatio: 16 / 9, // Geniş ekran oranı
                child: Image.network(
                  product.image.isNotEmpty
                      ? product.image
                      : 'https://via.placeholder.com/300x170?text=Görsel+Yok', // Daha büyük varsayılan görsel
                  fit:
                      BoxFit.cover, // Görselin alanı tamamen kaplamasını sağlar
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
              // Kalan alanı doldurması için Expanded kullandık
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, // İçeriği dikeyde yay
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 15, // Ürün adı font boyutu
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[850],
                          ),
                          maxLines: 2, // 2 satıra kadar sığdır
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          categoryText, // Birleştirilmiş kategori metni
                          style: TextStyle(
                            fontSize: 11, // Kategori font boyutu
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),

                    // Fiyat
                    Align(
                      alignment:
                          Alignment.bottomRight, // Fiyatı sağ alta hizala
                      child: Text(
                        '${product.price.toStringAsFixed(0)} ${product.priceUnit}',
                        style: TextStyle(
                          fontSize: 16, // Fiyat font boyutu
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700], // Daha belirgin yeşil
                        ),
                      ),
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
