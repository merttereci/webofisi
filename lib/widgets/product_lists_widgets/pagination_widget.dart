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
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // önceki ok
              _buildArrowButton(
                icon: Icons.chevron_left,
                isEnabled: provider.currentPage > 0,
                onTap: provider.currentPage > 0
                    ? () => provider.goToPage(provider.currentPage - 1)
                    : null,
              ),

              // sayfa bilgisi - sadece sayfa numarası
              Text(
                '${provider.currentPage + 1} / ${provider.totalPages}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),

              // sonraki ok
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

  // ok buton builder - çok kompakt
  Widget _buildArrowButton({
    required IconData icon,
    required bool isEnabled,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isEnabled
              ? const Color(0xFF667eea).withOpacity(0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isEnabled
                ? const Color(0xFF667eea).withOpacity(0.3)
                : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isEnabled ? const Color(0xFF667eea) : Colors.grey[400],
        ),
      ),
    );
  }
}
