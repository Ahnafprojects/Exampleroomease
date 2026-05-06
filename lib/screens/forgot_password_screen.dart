import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../widgets/widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  bool _loading = false;
  bool _success = false;

  void _submit() {
    if (_emailCtrl.text.isEmpty) return;
    setState(() => _loading = true);
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() { _loading = false; _success = true; });
    });
  }

  @override
  void dispose() { _emailCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: RoomEaseAppBar(title: 'Lupa Password'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: !_success ? _buildForm() : _buildSuccess(),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        const SizedBox(height: 32),
        Center(
          child: Container(
            width: 120, height: 120,
            decoration: BoxDecoration(color: const Color(0xFFEFF6FF), shape: BoxShape.circle),
            child: const Icon(Icons.mail_outline, size: 60, color: AppColors.navy),
          ),
        ),
        const SizedBox(height: 20),
        Text('Masukkan email kantor Anda',
          textAlign: TextAlign.center,
          style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.t1)),
        const SizedBox(height: 8),
        Text('Kami akan kirimkan link reset password ke email Anda.',
          textAlign: TextAlign.center,
          style: GoogleFonts.sora(fontSize: 13, color: AppColors.t2, height: 1.6)),
        const SizedBox(height: 24),
        AppInputField(
          label: 'Email Kantor',
          placeholder: 'nama@perusahaan.com',
          controller: _emailCtrl,
          leftIcon: Icons.mail_outline,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 24),
        PrimaryButton(
          label: 'Kirim Link Reset',
          onTap: _emailCtrl.text.isEmpty ? null : _submit,
          loading: _loading,
          color: _emailCtrl.text.isEmpty ? const Color(0xFFE5E7EB) : AppColors.amber,
          textColor: _emailCtrl.text.isEmpty ? AppColors.t3 : Colors.white,
        ),
      ],
    );
  }

  Widget _buildSuccess() {
    return Column(
      children: [
        const SizedBox(height: 32),
        Center(
          child: Container(
            width: 120, height: 120,
            decoration: BoxDecoration(color: AppColors.availableBg, shape: BoxShape.circle),
            child: const Icon(Icons.check_circle_outline, size: 60, color: AppColors.green),
          ),
        ),
        const SizedBox(height: 20),
        Text('Email Terkirim!', textAlign: TextAlign.center, style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.t1)),
        const SizedBox(height: 8),
        Text('Cek inbox ${_emailCtrl.text} dan ikuti instruksi reset password.',
          textAlign: TextAlign.center,
          style: GoogleFonts.sora(fontSize: 13, color: AppColors.t2, height: 1.6)),
        const SizedBox(height: 32),
        PrimaryButton(
          label: 'Kembali ke Login',
          onTap: () => Navigator.of(context).pushReplacementNamed('/login'),
        ),
      ],
    );
  }
}
