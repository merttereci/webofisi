// lib/widgets/product_description_section.dart
import 'package:flutter/material.dart';

class ProductDescriptionSection extends StatelessWidget {
  final String descriptionHtml; // HTML içeren açıklama

  const ProductDescriptionSection({
    Key? key,
    required this.descriptionHtml,
  }) : super(key: key);

  // HTML etiketlerini temizleme yardımcı fonksiyonu
  String _stripHtmlTags(String htmlString) {
    return htmlString.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ').trim();
  }

  @override
  Widget build(BuildContext context) {
    final cleanedDescription = _stripHtmlTags(descriptionHtml);
    if (cleanedDescription.isEmpty) {
      return const SizedBox.shrink(); // Açıklama boşsa gösterme
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: Colors.grey[300]),
        const SizedBox(height: 12), // Boşluğu artırdık
        Text(
          'Açıklama:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          cleanedDescription,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey[700],
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
