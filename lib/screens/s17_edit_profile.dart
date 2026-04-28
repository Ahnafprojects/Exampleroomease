import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../widgets/widgets.dart';
import '../data/mock_data.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _deptCtrl;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final user = AppData.user;
    _nameCtrl  = TextEditingController(text: user.name);
    _phoneCtrl = TextEditingController(text: user.phone);
    _deptCtrl  = TextEditingController(text: user.dept);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _deptCtrl.dispose();
    super.dispose();
  }

  void _save() {
    setState(() => _loading = true);
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      AppData.user
        ..name = _nameCtrl.text
        ..phone = _phoneCtrl.text
        ..dept = _deptCtrl.text
        ..initials = _nameCtrl.text.isNotEmpty
            ? _nameCtrl.text.trim().split(' ').map((w) => w[0]).take(2).join().toUpperCase()
            : AppData.user.initials;
      setState(() => _loading = false);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.green,
          content: Text('Profil berhasil diperbarui', style: GoogleFonts.sora(color: Colors.white)),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = AppData.user;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: RoomEaseAppBar(title: 'Edit Profil'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 88, height: 88,
                    decoration: BoxDecoration(color: AppColors.navy, shape: BoxShape.circle),
                    child: Center(
                      child: Text(user.initials, style: GoogleFonts.sora(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(color: AppColors.amber, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                      child: const Icon(Icons.camera_alt_outlined, size: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            AppInputField(label: 'Nama Lengkap', placeholder: 'Masukkan nama', controller: _nameCtrl, leftIcon: Icons.person_outline),
            const SizedBox(height: 16),
            AppInputField(label: 'Telepon', placeholder: '+62 xxx xxxx xxxx', controller: _phoneCtrl, leftIcon: Icons.phone_outlined, keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            AppInputField(label: 'Departemen', placeholder: 'Masukkan departemen', controller: _deptCtrl, leftIcon: Icons.business_outlined),
            const SizedBox(height: 16),
            // Email (readonly)
            AppInputField(
              label: 'Email',
              placeholder: user.email,
              leftIcon: Icons.mail_outline,
              enabled: false,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.info_outline, size: 14, color: AppColors.t3),
                const SizedBox(width: 6),
                Text('Email tidak dapat diubah', style: GoogleFonts.sora(fontSize: 11, color: AppColors.t3)),
              ],
            ),
            const SizedBox(height: 32),
            PrimaryButton(label: 'Simpan Perubahan', onTap: _save, loading: _loading),
          ],
        ),
      ),
    );
  }
}
