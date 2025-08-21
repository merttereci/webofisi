// lib/widgets/total_and_categories_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';

class TotalAndCategoriesWidget extends StatelessWidget {
  final VoidCallback? onShowCategoryModal; // callback eklendi

  const TotalAndCategoriesWidget({Key? key, this.onShowCategoryModal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // sol taraf - ürün sayısı
              Text(
                '${provider.filteredProducts.length} ürün bulundu',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),

              // sağ taraf - sadece modal butonu
              GestureDetector(
                onTap: () => _showCategoryModal(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: provider.selectedCategory != null
                        ? const Color(0xFF667eea).withOpacity(0.1)
                        : Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: provider.selectedCategory != null
                          ? const Color(0xFF667eea)
                          : Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.tune,
                        size: 16,
                        color: provider.selectedCategory != null
                            ? const Color(0xFF667eea)
                            : Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        provider.selectedCategory ?? 'Kategori',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: provider.selectedCategory != null
                              ? const Color(0xFF667eea)
                              : Colors.grey[700],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: provider.selectedCategory != null
                            ? const Color(0xFF667eea)
                            : Colors.grey[600],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // modal göster - callback kullan
  void _showCategoryModal(BuildContext context) {
    if (onShowCategoryModal != null) {
      onShowCategoryModal!(); // mainscreen'den modal aç
    } else {
      // fallback: local modal aç (eski yöntem)
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          padding: EdgeInsets.all(20),
          child: Text('Modal callback çalışmıyor'),
        ),
      );
    }
  }
}
