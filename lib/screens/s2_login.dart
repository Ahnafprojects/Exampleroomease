import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../widgets/widgets.dart';
import '../data/mock_data.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _showPw = false;
  bool _loading = false;
  String? _emailError;
  String? _toast;
  bool _toastVisible = false;

  void _showToast(String msg) {
    setState(() { _toast = msg; _toastVisible = true; });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _toastVisible = false);
    });
  }

  void _handleLogin() {
    setState(() => _emailError = null);
    if (_emailCtrl.text.isEmpty) {
      setState(() => _emailError = 'Email tidak boleh kosong');
      return;
    }
    if (_passwordCtrl.text.isEmpty) return;
    setState(() => _loading = true);

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() => _loading = false);
      final email = _emailCtrl.text;
      final pw = _passwordCtrl.text;

      if (email == 'admin@perusahaan.com' && pw == 'admin123') {
        AppData.user
          ..isAdmin = true
          ..name = 'Admin GA'
          ..initials = 'AG'
          ..role = 'Admin GA'
          ..dept = 'General Affairs';
        Navigator.of(context).pushReplacementNamed('/main', arguments: {'tab': 3});
      } else if (pw == 'wrong' || pw.length < 3) {
        _showToast('Email atau password salah. Coba lagi.');
      } else if (email.isNotEmpty && pw.isNotEmpty) {
        AppData.user
          ..isAdmin = false
          ..name = 'Andi Santoso'
          ..initials = 'AS'
          ..role = 'Karyawan'
          ..dept = 'Tim Engineering';
        Navigator.of(context).pushReplacementNamed('/main');
      } else {
        _showToast('Email atau password salah. Coba lagi.');
      }
    });
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          Column(
            children: [
              // Header
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
                ),
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 24, bottom: 32, left: 20, right: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(color: AppColors.amber, borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.business, size: 24, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Text('RoomEase', style: GoogleFonts.sora(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text('Selamat datang kembali', style: GoogleFonts.sora(fontSize: 14, color: const Color(0xFF93A8C8))),
                  ],
                ),
              ),

              // Form
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 32, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppInputField(
                        label: 'Email Kantor',
                        placeholder: 'nama@perusahaan.com',
                        controller: _emailCtrl,
                        leftIcon: Icons.mail_outline,
                        keyboardType: TextInputType.emailAddress,
                        errorText: _emailError,
                      ),
                      const SizedBox(height: 20),
                      AppInputField(
                        label: 'Password',
                        placeholder: '••••••••',
                        controller: _passwordCtrl,
                        leftIcon: Icons.lock_outline,
                        rightIcon: _showPw ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        onRightIconTap: () => setState(() => _showPw = !_showPw),
                        obscureText: !_showPw,
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pushNamed('/forgot-password'),
                          child: Text('Lupa password?', style: GoogleFonts.sora(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.amber)),
                        ),
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(label: 'Masuk', onTap: _handleLogin, loading: _loading),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text('atau', style: GoogleFonts.sora(fontSize: 11, color: AppColors.t3)),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pushReplacementNamed('/main'),
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.business, size: 20, color: AppColors.navy),
                              const SizedBox(width: 8),
                              Text('Masuk dengan SSO Perusahaan', style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.t1)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Toast
          if (_toastVisible && _toast != null)
            Positioned(
              top: MediaQuery.of(context).padding.top + 79,
              left: 20,
              right: 20,
              child: AnimatedOpacity(
                opacity: _toastVisible ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.navy,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 12)],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_rounded, size: 20, color: AppColors.amber),
                      const SizedBox(width: 10),
                      Expanded(child: Text(_toast!, style: GoogleFonts.sora(fontSize: 14, color: Colors.white))),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
