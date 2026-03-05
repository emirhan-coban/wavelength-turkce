import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../online/online_lobby_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nameController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Eğer zaten giriş yapmışsa direkt lobby'ye git
    if (AuthService.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnlineLobbyScreen()),
        );
      });
    }
  }

  Future<void> _signInAnonymously() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _errorMessage = 'Lütfen bir isim gir');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await AuthService.signInAnonymously(name);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnlineLobbyScreen()),
        );
      }
    } catch (e) {
      setState(() => _errorMessage = 'Giriş başarısız: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await AuthService.signInWithGoogle();
      if (user != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnlineLobbyScreen()),
        );
      }
    } catch (e) {
      setState(() => _errorMessage = 'Google giriş başarısız: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Online Giriş'),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                kToolbarHeight,
          ),
          child: IntrinsicHeight(
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Icon
                Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.primaryOrange.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.primaryOrange.withValues(alpha: 0.4),
                ),
              ),
              child: const Icon(
                Icons.wifi,
                size: 36,
                color: AppTheme.primaryOrange,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Online Oyna',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Arkadaşlarınla farklı cihazlardan\naynı oyuna katıl',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 32),

            // Anonim giriş - İsim alanı
            Container(
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.divider),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'HIZLI GİRİŞ',
                    style: TextStyle(
                      color: AppTheme.primaryOrange,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Oyuncu adını gir...',
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: AppTheme.textSecondary,
                        size: 20,
                      ),
                    ),
                    onSubmitted: (_) => _signInAnonymously(),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _signInAnonymously,
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppTheme.background,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.play_arrow_rounded, size: 20),
                                SizedBox(width: 8),
                                Text('İsimle Giriş Yap'),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Divider
            Row(
              children: [
                Expanded(child: Container(height: 1, color: AppTheme.divider)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'veya',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(child: Container(height: 1, color: AppTheme.divider)),
              ],
            ),

            const SizedBox(height: 16),

            // Google Sign In
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _isLoading ? null : _signInWithGoogle,
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppTheme.cardColor,
                  side: BorderSide(
                    color: AppTheme.textSecondary.withValues(alpha: 0.3),
                  ),
                  foregroundColor: AppTheme.textPrimary,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.g_mobiledata, size: 28),
                    SizedBox(width: 8),
                    Text('Google ile Giriş Yap'),
                  ],
                ),
              ),
            ),

            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppTheme.error.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: AppTheme.error, fontSize: 12),
                ),
              ),
            ],

            const Spacer(),
            Text(
              'Veriler güvenli şekilde Firebase\'de saklanır',
              style: TextStyle(
                color: AppTheme.textTertiary.withValues(alpha: 0.8),
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
