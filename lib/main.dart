import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_ofisi_mobile/providers/cart_provider.dart';
import 'package:web_ofisi_mobile/providers/favorites_provider.dart';
import 'package:web_ofisi_mobile/screens/auth_screen.dart';
import 'package:web_ofisi_mobile/screens/main_screen.dart';
import 'providers/product_provider.dart';
import 'providers/user_provider.dart';
import 'services/mock_api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🚀 === UYGULAMA BAŞLIYOR ===');

  // FARKLI IP'LERI TEST ET
  final testUrls = [
    'http://10.0.2.2:3000/uyeler', // Android emulator default
    'http://127.0.0.1:3000/uyeler', // Localhost
    'http://localhost:3000/uyeler', // Localhost alternative
    'http://192.168.1.100:3000/uyeler', // Local network IP (değişebilir)
  ];

  for (String url in testUrls) {
    print('🔌 Test ediliyor: $url');
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 3));

      print('📊 [$url] Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final users = jsonDecode(response.body) as List;
        print('✅ BAŞARILI! $url');
        print('👥 Kullanıcı sayısı: ${users.length}');

        // MockApiService'teki baseUrl'yi güncelle
        print('🔧 Bu URL çalışıyor: $url');
        print('🔧 MockApiService.baseUrl\'yi şuna değiştir:');
        print(
            '   static const String baseUrl = \'${url.replaceAll('/uyeler', '')}\';');
        break;
      }
    } catch (e) {
      print('❌ [$url] Hata: ${e.toString().split(':')[0]}');
    }
  }

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
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
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
                  const SizedBox(height: 10),
                  Text(
                    'Debug log\'larını kontrol edin',
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
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
