// lib/screens/product_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_ofisi_mobile/widgets/product_lists_widgets/total_and_categories_widget.dart';
import '../providers/product_provider.dart';
import '../widgets/product_lists_widgets/search_bar_widget.dart';
import '../widgets/product_lists_widgets/product_card.dart';
import '../widgets/product_lists_widgets/pagination_widget.dart';
import '../widgets/product_lists_widgets/loading_widget.dart';
import '../widgets/product_lists_widgets/error_widget.dart';

class ProductListScreen extends StatefulWidget {
  final VoidCallback? onShowCategoryModal; // callback eklendi

  const ProductListScreen({Key? key, this.onShowCategoryModal})
      : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  // scroll controller tanımı
  final ScrollController _scrollController = ScrollController();

  // product provider'ı dinlemek için değişken
  late ProductProvider _productProvider;

  @override
  void initState() {
    super.initState();
    // product provider'ı başlat
    _productProvider = context.read<ProductProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _productProvider.loadProducts();
    });
    // product provider'daki değişiklikleri dinlemek için listener ekle
    _productProvider.addListener(_scrollToTopOnStateChange);
  }

  // product provider değiştiğinde çağrılacak metod
  void _scrollToTopOnStateChange() {
    // eğer kaydırma kontrolcüsü bağlıysa ve en üstte değilse, en üste kaydır
    if (_scrollController.hasClients && _scrollController.offset != 0.0) {
      _scrollController.animateTo(
        0.0, // en üste kaydır
        duration: const Duration(milliseconds: 300), // hafif bir animasyonla
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    // controller ve listener'ı dispose etmeyi unutmayın
    _scrollController.dispose();
    _productProvider.removeListener(_scrollToTopOnStateChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Web Ofisi', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey[800],
        elevation: 1,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => context.read<ProductProvider>().loadProducts(),
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          return Column(
            children: [
              // arama çubuğu
              SearchBarWidget(),

              // içerik
              Expanded(
                child: productProvider.isLoading
                    ? LoadingWidget()
                    : productProvider.errorMessage.isNotEmpty
                        ? Error1Widget(
                            message: productProvider.errorMessage,
                            onRetry: () => productProvider.loadProducts(),
                          )
                        : productProvider.displayedProducts.isEmpty &&
                                productProvider.searchQuery.isNotEmpty
                            ? Error1Widget(
                                message: productProvider.errorMessage,
                                onRetry: () => productProvider.loadProducts(),
                              )
                            : Column(
                                children: [
                                  // sonuç sayısı ve kategori seçici - callback geçildi
                                  TotalAndCategoriesWidget(
                                    onShowCategoryModal:
                                        widget.onShowCategoryModal,
                                  ),

                                  // ürün kartları
                                  Expanded(
                                    child: ListView.builder(
                                      // scroll controller'ı listview'e ata
                                      controller: _scrollController,
                                      padding: EdgeInsets.all(16.0),
                                      itemCount: productProvider
                                          .displayedProducts.length,
                                      itemBuilder: (context, index) {
                                        return ProductCard(
                                          product: productProvider
                                              .displayedProducts[index],
                                        );
                                      },
                                    ),
                                  ),

                                  // pagination kontrolleri
                                  PaginationWidget(),
                                ],
                              ),
              ),
            ],
          );
        },
      ),
    );
  }
}
