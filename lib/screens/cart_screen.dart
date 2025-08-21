// lib/screens/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Sepetim',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey[800],
        elevation: 1,
        automaticallyImplyLeading: false, // geri butonu gizle (tab navigation)
        actions: [
          // kullanıcı avatarı küçük versiyonu
          Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              if (!userProvider.isLoggedIn) return const SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.blue[600],
                  child: Text(
                    userProvider.userInitials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // büyük sepet ikonu
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_cart_outlined,
                size: 80,
                color: Colors.blue[300],
              ),
            ),
            const SizedBox(height: 24),

            // başlık
            Text(
              'Sepetiniz Boş',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),

            // açıklama
            Text(
              'Henüz sepetinizde ürün bulunmuyor.\nAlışverişe başlamak için ürünler sekmesini ziyaret edin.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),

            // alışverişe başla butonu
            ElevatedButton.icon(
              onPressed: () {
                // ürünler sekmesine geç (index 1)
                // bu işlemi parent widget'tan yapacağız
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Ürünler sekmesine geçmek için alttaki menüyü kullanın'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
              icon: const Icon(Icons.shopping_bag_outlined),
              label: const Text('Alışverişe Başla'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
