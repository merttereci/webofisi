import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';

class PaginationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        if (provider.totalPages <= 1) return SizedBox.shrink();

        return Container(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Önceki sayfa butonu
              IconButton(
                onPressed: provider.currentPage > 0
                    ? () => provider.goToPage(provider.currentPage - 1)
                    : null,
                icon: Icon(Icons.chevron_left),
                color: provider.currentPage > 0
                    ? Colors.blue[600]
                    : Colors.grey[400],
              ),

              // Sayfa numaraları
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildPageNumbers(provider),
                  ),
                ),
              ),

              // Sonraki sayfa butonu
              IconButton(
                onPressed: provider.currentPage < provider.totalPages - 1
                    ? () => provider.goToPage(provider.currentPage + 1)
                    : null,
                icon: Icon(Icons.chevron_right),
                color: provider.currentPage < provider.totalPages - 1
                    ? Colors.blue[600]
                    : Colors.grey[400],
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildPageNumbers(ProductProvider provider) {
    List<Widget> pageNumbers = [];

    // Gösterilecek sayfa numaralarını hesapla
    int start = 0;
    int end = provider.totalPages;

    // Eğer çok fazla sayfa varsa, sadece mevcut sayfanın etrafındakileri göster
    if (provider.totalPages > 7) {
      start = (provider.currentPage - 3).clamp(0, provider.totalPages - 7);
      end = (start + 7).clamp(7, provider.totalPages);

      // İlk sayfa
      if (start > 0) {
        pageNumbers.add(_buildPageButton(provider, 0));
        if (start > 1) {
          pageNumbers.add(Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text('...', style: TextStyle(color: Colors.grey[600])),
          ));
        }
      }
    }

    // Sayfa numaralarını ekle
    for (int i = start; i < end; i++) {
      pageNumbers.add(_buildPageButton(provider, i));
    }

    // Son sayfa
    if (provider.totalPages > 7 && end < provider.totalPages) {
      if (end < provider.totalPages - 1) {
        pageNumbers.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('...', style: TextStyle(color: Colors.grey[600])),
        ));
      }
      pageNumbers.add(_buildPageButton(provider, provider.totalPages - 1));
    }

    return pageNumbers;
  }

  Widget _buildPageButton(ProductProvider provider, int pageIndex) {
    bool isActive = pageIndex == provider.currentPage;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: () => provider.goToPage(pageIndex),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? Colors.blue[600] : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive ? Colors.blue[600]! : Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: Text(
            '${pageIndex + 1}',
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey[700],
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
