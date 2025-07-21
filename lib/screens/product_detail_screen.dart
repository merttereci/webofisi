// lib/screens/product_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/product_details_widgets/product_image_gallery.dart'; // Yeni galeri widget'ını import et
import '../widgets/product_details_widgets/product_demo_buttons.dart'; // Yeni demo butonları widget'ını import et
import '../widgets/product_details_widgets/product_detail_row.dart'; // Yeni detay satırı widget'ını import et
import '../widgets/product_details_widgets/product_description_section.dart'; // Yeni açıklama widget'ını import et

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({Key? key, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Tüm resimleri birleştiriyoruz: önce ana resim, sonra diğer resimler
    final List<String> allImages = [product.image, ...product.otherImages];

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey[800],
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
            horizontal: 16.0, vertical: 20.0), // Genel paddingi artırdık
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resim Galerisi
            ProductImageGallery(imageUrls: allImages),
            const SizedBox(height: 24), // Boşluğu artırdık

            // Demo ve Admin Demo Butonları
            ProductDemoButtons(
                demoUrl: product.demo, adminDemoUrl: product.demoAdmin),
            const SizedBox(height: 24), // Boşluğu artırdık

            // Ürün Adı
            Text(
              product.name,
              style: TextStyle(
                fontSize: 26, // Boyutu büyüttük
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12), // Boşluğu artırdık

            // Kategori(ler)
            Text(
              'Kategori: ${product.category.isNotEmpty ? product.category.join(', ') : 'Belirtilmemiş'}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12), // Boşluğu artırdık

            // Ürün Fiyatı
            Text(
              'Fiyat: ${product.price.toStringAsFixed(0)} ${product.priceUnit}',
              style: TextStyle(
                fontSize: 24, // Boyutu büyüttük
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            const SizedBox(height: 24), // Boşluğu artırdık

            // Ürün Kod Bilgileri
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 12), // Boşluğu artırdık
            ProductDetailRow(title: 'Ürün Kodu:', value: product.code),
            ProductDetailRow(title: 'Kodlama:', value: product.coding),
            ProductDetailRow(title: 'PHP Versiyon:', value: product.phpVersion),
            const SizedBox(height: 24), // Boşluğu artırdık

            // Açıklama Bölümü
            ProductDescriptionSection(descriptionHtml: product.description),

            // Eğer istersen buraya ek özellikler, yorumlar vb. gelebilir
          ],
        ),
      ),
    );
  }
}
