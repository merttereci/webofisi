// lib/screens/main_screen.dart
import 'package:flutter/material.dart';
import 'package:web_ofisi_mobile/widgets/product_lists_widgets/category_selector_modal.dart';
import 'tabs/home_tab.dart';
import 'tabs/products_tab.dart';
import 'tabs/cart_tab.dart';
import 'tabs/profile_tab.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // tab değişikliği için callback
  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _showCategoryModal() {
    showModalBottomSheet(
      context: context, // mainscreen context - navbar dışında!
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CategorySelectorModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeTab(onTabChange: _changeTab), // callback eklendi
          ProductsTab(
              onShowCategoryModal: _showCategoryModal), // callback geçildi
          const CartTab(),
          const ProfileTab(),
        ],
      ),
      // floating bottom navbar burada
      bottomNavigationBar: _buildFloatingNavbar(),
    );
  }

  // floating bottom navbar widget'ı
  Widget _buildFloatingNavbar() {
    return Container(
      margin: const EdgeInsets.only(
        top: 5,
        left: 15,
        right: 15,
        bottom: 10, // ekranın altından boşluk
      ),
      decoration: BoxDecoration(
        // gradient arkaplan
        gradient: const LinearGradient(
          colors: [
            Color(0xFF667eea), // mavi
            Color(0xFF764ba2), // mor
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25), // yuvarlak köşeler
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Ana Sayfa',
                index: 0,
              ),
              _buildNavItem(
                icon: Icons.grid_view_outlined,
                activeIcon: Icons.grid_view,
                label: 'Ürünler',
                index: 1,
              ),
              _buildNavItem(
                icon: Icons.shopping_cart_outlined,
                activeIcon: Icons.shopping_cart,
                label: 'Sepet',
                index: 2,
              ),
              _buildNavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profil',
                index: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // navbar item builder
  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 16 : 8,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: Colors.white,
              size: isActive ? 26 : 24,
            ),
            if (isActive) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
