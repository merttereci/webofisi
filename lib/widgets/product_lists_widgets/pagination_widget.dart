import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';

class PaginationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        // sayfa yoksa widget gösterme
        if (provider.totalPages <= 1) return SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          margin: const EdgeInsets.only(bottom: 8), // Alt margin azaltıldı
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8), // Köşeler yuvarlatıldı
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // önceki ok - daha küçük
              _buildArrowButton(
                icon: Icons.chevron_left,
                isEnabled: provider.currentPage > 0,
                onTap: provider.currentPage > 0
                    ? () => provider.goToPage(provider.currentPage - 1)
                    : null,
              ),

              // sayfa bilgisi - daha küçük font
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${provider.currentPage + 1} / ${provider.totalPages}',
                  style: TextStyle(
                    fontSize: 14, // Font size küçültüldü
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
              ),

              // sonraki ok - daha küçük
              _buildArrowButton(
                icon: Icons.chevron_right,
                isEnabled: provider.currentPage < provider.totalPages - 1,
                onTap: provider.currentPage < provider.totalPages - 1
                    ? () => provider.goToPage(provider.currentPage + 1)
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }

  // ok buton builder - daha kompakt
  Widget _buildArrowButton({
    required IconData icon,
    required bool isEnabled,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        width: 30, // 36'dan 30'a küçültüldü
        height: 30, // 36'dan 30'a küçültüldü
        decoration: BoxDecoration(
          color: isEnabled
              ? const Color(0xFF667eea).withOpacity(0.08)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(6), // 8'den 6'ya küçültüldü
          border: Border.all(
            color: isEnabled
                ? const Color(0xFF667eea).withOpacity(0.2)
                : Colors.grey[300]!,
            width: 0.5, // Border width küçültüldü
          ),
        ),
        child: Icon(
          icon,
          size: 18, // 20'den 18'e küçültüldü
          color: isEnabled ? const Color(0xFF667eea) : Colors.grey[400],
        ),
      ),
    );
  }
}
