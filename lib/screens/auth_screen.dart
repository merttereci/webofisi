import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tables/uyeler.dart';
import '../providers/user_provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();

  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();
  final TextEditingController _registerNameController = TextEditingController();
  final TextEditingController _registerSurnameController =
      TextEditingController();
  final TextEditingController _registerEmailController =
      TextEditingController();
  final TextEditingController _registerPhoneController =
      TextEditingController();
  final TextEditingController _registerPasswordController =
      TextEditingController();
  final TextEditingController _registerConfirmPasswordController =
      TextEditingController();

  bool _isLogin = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _registerNameController.dispose();
    _registerSurnameController.dispose();
    _registerEmailController.dispose();
    _registerPhoneController.dispose();
    _registerPasswordController.dispose();
    _registerConfirmPasswordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_loginFormKey.currentState!.validate()) {
      final userProvider = context.read<UserProvider>();

      final success = await userProvider.login(
        _loginEmailController.text,
        _loginPasswordController.text,
      );

      if (success) {
        _showSnackBar(
            'Giriş başarılı! Hoş geldiniz ${userProvider.userFullName}!',
            isError: false);
        // Navigation AuthWrapper tarafından otomatik yapılacak
      } else {
        _showSnackBar('Geçersiz e-posta veya şifre.');
      }
    }
  }

  void _register() async {
    if (_registerFormKey.currentState!.validate()) {
      // Şifre eşleşme kontrolü
      if (_registerPasswordController.text !=
          _registerConfirmPasswordController.text) {
        _showSnackBar('Şifreler eşleşmiyor.');
        return;
      }

      final newUser = TabloUyeler(
        id: 0, // ID AuthService tarafından atanacak
        ad: _registerNameController.text,
        soyad: _registerSurnameController.text,
        email: _registerEmailController.text,
        sifre: _registerPasswordController.text,
        telefon: _registerPhoneController.text,
        statu: 0, // Yeni kullanıcı
        durum: 1, // Aktif
      );

      final userProvider = context.read<UserProvider>();
      final result = await userProvider.register(newUser);

      if (result['success']) {
        _showSnackBar(
            'Kayıt başarılı! Hoş geldiniz ${userProvider.userFullName}!',
            isError: false);
        // Navigation AuthWrapper tarafından otomatik yapılacak
      } else {
        _showSnackBar(result['message'] ?? 'Kayıt işlemi başarısız.');
      }
    }
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(message, style: const TextStyle(fontWeight: FontWeight.w500)),
        backgroundColor: isError ? Colors.red[400] : Colors.green[400],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLogo(),
                      const SizedBox(height: 32),
                      _buildAuthCard(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      height: 150,
      width: 400,
      child: Image.asset(
        'assets/logo/logo.png',
        height: 150,
        width: 400,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildAuthCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            _buildAuthForm(),
            const SizedBox(height: 24),
            _buildActionButton(),
            const SizedBox(height: 24),
            _buildToggleButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          _isLogin ? 'Tekrar Hoş Geldiniz!' : 'Hesap Oluşturun',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          _isLogin
              ? 'Hesabınıza giriş yaparak devam edin'
              : 'Yeni hesap oluşturarak başlayın',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAuthForm() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: _isLogin ? _buildLoginForm() : _buildRegisterForm(),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: [
          _buildModernTextField(
            controller: _loginEmailController,
            label: 'E-posta Adresi',
            icon: Icons.email_outlined,
            validator: (value) => value!.isEmpty || !value.contains('@')
                ? 'Geçerli bir e-posta girin'
                : null,
          ),
          const SizedBox(height: 20),
          _buildModernTextField(
            controller: _loginPasswordController,
            label: 'Şifre',
            icon: Icons.lock_outline,
            isPassword: true,
            obscureText: _obscurePassword,
            onToggleVisibility: () {
              setState(() => _obscurePassword = !_obscurePassword);
            },
            validator: (value) =>
                value!.isEmpty ? 'Şifre boş bırakılamaz' : null,
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // Şifremi unuttum fonksiyonu - ileride implement edilebilir
                _showSnackBar('Şifre sıfırlama özelliği henüz aktif değil.',
                    isError: false);
              },
              child: Text(
                'Şifremi Unuttum?',
                style: TextStyle(
                  color: const Color(0xFF667eea),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Form(
      key: _registerFormKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildModernTextField(
                  controller: _registerNameController,
                  label: 'Ad',
                  icon: Icons.person_outline,
                  validator: (value) => value!.isEmpty ? 'Ad gerekli' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildModernTextField(
                  controller: _registerSurnameController,
                  label: 'Soyad',
                  icon: Icons.person_outline,
                  validator: (value) => value!.isEmpty ? 'Soyad gerekli' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildModernTextField(
            controller: _registerEmailController,
            label: 'E-posta Adresi',
            icon: Icons.email_outlined,
            validator: (value) => value!.isEmpty || !value.contains('@')
                ? 'Geçerli bir e-posta girin'
                : null,
          ),
          const SizedBox(height: 20),
          _buildModernTextField(
            controller: _registerPhoneController,
            label: 'Telefon Numarası',
            icon: Icons.phone_outlined,
            validator: (value) =>
                value!.isEmpty ? 'Telefon numarası gerekli' : null,
          ),
          const SizedBox(height: 20),
          _buildModernTextField(
            controller: _registerPasswordController,
            label: 'Şifre',
            icon: Icons.lock_outline,
            isPassword: true,
            obscureText: _obscurePassword,
            onToggleVisibility: () {
              setState(() => _obscurePassword = !_obscurePassword);
            },
            validator: (value) =>
                value!.length < 6 ? 'Şifre en az 6 karakter olmalı' : null,
          ),
          const SizedBox(height: 20),
          _buildModernTextField(
            controller: _registerConfirmPasswordController,
            label: 'Şifre Tekrar',
            icon: Icons.lock_outline,
            isPassword: true,
            obscureText: _obscureConfirmPassword,
            onToggleVisibility: () {
              setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword);
            },
            validator: (value) => value != _registerPasswordController.text
                ? 'Şifreler eşleşmiyor'
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(fontSize: 16, color: Color(0xFF2D3748)),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFF667eea)),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.grey[600],
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF667eea), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildActionButton() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF667eea).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed:
                userProvider.isLoading ? null : (_isLogin ? _login : _register),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: userProvider.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    _isLogin ? 'Giriş Yap' : 'Hesap Oluştur',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildToggleButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _isLogin ? 'Hesabınız yok mu?' : 'Zaten hesabınız var mı?',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 15,
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _isLogin = !_isLogin;
              // Form değiştirirken controller'ları temizle
              _clearFormFields();
            });
          },
          child: Text(
            _isLogin ? 'Kayıt Olun' : 'Giriş Yapın',
            style: const TextStyle(
              color: Color(0xFF667eea),
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }

  void _clearFormFields() {
    _loginEmailController.clear();
    _loginPasswordController.clear();
    _registerNameController.clear();
    _registerSurnameController.clear();
    _registerEmailController.clear();
    _registerPhoneController.clear();
    _registerPasswordController.clear();
    _registerConfirmPasswordController.clear();
  }
}
