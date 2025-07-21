// lib/widgets/total_and_categories_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart'; // ProductProvider'ı import etmeyi unutmayın

class TotalAndCategoriesWidget extends StatelessWidget {
  const TotalAndCategoriesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ProductProvider'a erişmek için Consumer kullanın
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        // DropdownMenuItems için kategori listesini hazırla
        List<DropdownMenuItem<String>> dropdownItems = [
          DropdownMenuItem(
            value: 'Tümü', // Tüm kategorileri göster seçeneği
            child: Text('Tüm Kategoriler'),
          ),
        ];

        dropdownItems.addAll(
          provider.availableCategories.map((category) {
            return DropdownMenuItem(
              value: category,
              child: Text(category),
            );
          }).toList(),
        );

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${provider.filteredProducts.length} ürün bulundu',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Expanded(
                // Dropdown'un sağa yayılmasını sağlar
                child: Align(
                  // Sağda hizalama için
                  alignment: Alignment.centerRight,
                  child: DropdownButton<String>(
                    value: provider.selectedCategory, // Seçili kategori
                    hint: const Text('Kategori Seç'),
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? newValue) {
                      // ProductProvider'daki kategori seçme metodunu çağır
                      context.read<ProductProvider>().selectCategory(newValue);
                    },
                    items: dropdownItems, // Hazırladığımız item listesi
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
