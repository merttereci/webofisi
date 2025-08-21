import 'package:flutter/material.dart';
import '../cart_screen.dart';

class CartTab extends StatelessWidget {
  const CartTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
          case '/cart':
            return MaterialPageRoute(
              builder: (context) => const CartScreen(),
              settings: settings,
            );
          // gelecekte: sepet detayı, ödeme sayfaları vs.
          default:
            return MaterialPageRoute(
              builder: (context) => const CartScreen(),
              settings: settings,
            );
        }
      },
    );
  }
}
