import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_ofisi_mobile/providers/cart_provider.dart';
import 'package:web_ofisi_mobile/screens/auth_screen.dart';
import 'package:web_ofisi_mobile/screens/main_screen.dart';
import 'providers/product_provider.dart';
import 'providers/user_provider.dart';
import 'services/mock_api_service.dart'; // YENİ IMPORT

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ==================== APP START ====================
  print('🚀 Uygulama başlatılıyor...');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'Web Ofisi Mobile',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AuthWrapper(),
      ),
    );
  }
}

// Oturum durumuna göre ekran seçimi
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        // Loading durumu
        if (userProvider.isLoading) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Oturum kontrol ediliyor...',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          );
        }

        // Giriş yapmış mı kontrolü
        if (userProvider.isLoggedIn) {
          return const MainScreen();
        } else {
          return const AuthScreen();
        }
      },
    );
  }
}
