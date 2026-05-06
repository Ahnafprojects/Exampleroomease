import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../widgets/widgets.dart';
import '../data/mock_data.dart';

const _kDepts = [
  'Engineering', 'Product', 'Design', 'Marketing',
  'Sales', 'Finance', 'HR', 'General Affairs', 'Operations',
];

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  String? _dept;
  bool _deptOpen = false;
  bool _showPw = false;
  bool _agree = false;
  bool _loading = false;
  Map<String, String?> _errs = {};
  String? _toast;
  bool _toastVisible = false;
  bool _toastSuccess = false;

  void _showToast(String msg, {bool success = false}) {
    setState(() {
      _toast = msg;
      _toastVisible = true;
      _toastSuccess = success;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _toastVisible = false);
    });
  }

  int get _strength {
    final pw = _passwordCtrl.text;
    int s = 0;
    if (pw.length >= 8) s++;
    if (RegExp(r'[A-Z]').hasMatch(pw)) s++;
    if (RegExp(r'[0-9]').hasMatch(pw)) s++;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(pw)) s++;
    return s;
  }

  String get _strengthLabel =>
      ['Terlalu lemah', 'Lemah', 'Cukup', 'Baik', 'Kuat'][_strength];

  Color get _strengthColor => const [
        Color(0xFFE5E7EB),
        AppColors.red,
        AppColors.amber,
        AppColors.blue,
        AppColors.green,
      ][_strength];

  void _handleSubmit() {
    final errs = <String, String?>{};
    if (_nameCtrl.text.trim().isEmpty) errs['name'] = 'Nama wajib diisi';
    if (_emailCtrl.text.trim().isEmpty) {
      errs['email'] = 'Email wajib diisi';
    } else if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(_emailCtrl.text)) {
      errs['email'] = 'Format email tidak valid';
    }
    if (_dept == null) errs['dept'] = 'Pilih departemen';
    if (_passwordCtrl.text.isEmpty) {
      errs['password'] = 'Password wajib diisi';
    } else if (_passwordCtrl.text.length < 8) {
      errs['password'] = 'Minimal 8 karakter';
    }
    if (_confirmCtrl.text != _passwordCtrl.text) {
      errs['confirm'] = 'Password tidak cocok';
    }

    setState(() => _errs = errs);

    if (!_agree) {
      _showToast('Setujui Syarat & Ketentuan terlebih dahulu');
      return;
    }
    if (errs.isNotEmpty) return;

    setState(() => _loading = true);
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() => _loading = false);
      final name = _nameCtrl.text.trim();
      AppData.user
        ..name = name
        ..email = _emailCtrl.text.trim()
        ..dept = _dept ?? ''
        ..initials = name
            .split(' ')
            .take(2)
            .map((w) => w.isEmpty ? '' : w[0].toUpperCase())
            .join()
        ..isAdmin = false
        ..role = 'Karyawan';
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(
            '/otp-verify',
            arguments: _emailCtrl.text.trim(),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pw = _passwordCtrl.text;
    final strength = _strength;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          AuthShell(
            isLogin: false,
            onSwitchToLogin: () =>
                Navigator.of(context).pushReplacementNamed('/login'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppInputField(
                  label: 'Nama Lengkap',
                  placeholder: 'Andi Santoso',
                  controller: _nameCtrl,
                  leftIcon: Icons.person_outline,
                  errorText: _errs['name'],
                ),
                const SizedBox(height: 14),
                AppInputField(
                  label: 'Email Kantor',
                  placeholder: 'nama@perusahaan.com',
                  controller: _emailCtrl,
                  leftIcon: Icons.mail_outline,
                  keyboardType: TextInputType.emailAddress,
                  errorText: _errs['email'],
                ),
                const SizedBox(height: 14),
                _DeptDropdown(
                  value: _dept,
                  open: _deptOpen,
                  error: _errs['dept'],
                  onToggle: () => setState(() => _deptOpen = !_deptOpen),
                  onSelect: (d) => setState(() {
                    _dept = d;
                    _deptOpen = false;
                  }),
                ),
                const SizedBox(height: 14),
                AppInputField(
                  label: 'Password',
                  placeholder: 'Min. 8 karakter',
                  controller: _passwordCtrl,
                  leftIcon: Icons.lock_outline,
                  rightIcon: _showPw
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  onRightIconTap: () => setState(() => _showPw = !_showPw),
                  obscureText: !_showPw,
                  errorText: _errs['password'],
                  onChange: (_) => setState(() {}),
                ),
                if (pw.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ...List.generate(4, (i) => Expanded(
                        child: Container(
                          height: 4,
                          margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
                          decoration: BoxDecoration(
                            color: i < strength ? _strengthColor : AppColors.border,
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                      )),
                      const SizedBox(width: 8),
                      Text(
                        _strengthLabel,
                        style: GoogleFonts.sora(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _strengthColor,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 14),
                AppInputField(
                  label: 'Konfirmasi Password',
                  placeholder: 'Ulangi password',
                  controller: _confirmCtrl,
                  leftIcon: Icons.lock_outline,
                  obscureText: !_showPw,
                  errorText: _errs['confirm'],
                ),
                const SizedBox(height: 18),
                GestureDetector(
                  onTap: () => setState(() => _agree = !_agree),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        margin: const EdgeInsets.only(top: 1),
                        width: 18, height: 18,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: _agree ? AppColors.navy : AppColors.border,
                            width: 1.5,
                          ),
                          color: _agree ? AppColors.navy : Colors.white,
                        ),
                        child: _agree
                            ? const Icon(Icons.check, size: 11, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.sora(
                              fontSize: 12, color: AppColors.t2, height: 1.5,
                            ),
                            children: [
                              const TextSpan(text: 'Saya setuju dengan '),
                              TextSpan(
                                text: 'Syarat & Ketentuan',
                                style: GoogleFonts.sora(
                                  fontSize: 12, fontWeight: FontWeight.w600,
                                  color: AppColors.navy,
                                ),
                              ),
                              const TextSpan(text: ' dan '),
                              TextSpan(
                                text: 'Kebijakan Privasi',
                                style: GoogleFonts.sora(
                                  fontSize: 12, fontWeight: FontWeight.w600,
                                  color: AppColors.navy,
                                ),
                              ),
                              const TextSpan(text: ' RoomEase.'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                AuthCTAButton(
                  label: 'Buat Akun',
                  loading: _loading,
                  onTap: _handleSubmit,
                ),
                const SizedBox(height: 16),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sudah punya akun? ',
                        style: GoogleFonts.sora(fontSize: 12, color: AppColors.t2),
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.of(context).pushReplacementNamed('/login'),
                        child: Text(
                          'Masuk di sini',
                          style: GoogleFonts.sora(
                            fontSize: 12, fontWeight: FontWeight.w600,
                            color: AppColors.amber,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_toastVisible && _toast != null)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 20, right: 20,
              child: AnimatedOpacity(
                opacity: _toastVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: _toastSuccess ? AppColors.green : AppColors.navy,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 12),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _toastSuccess
                            ? Icons.check_circle_outline
                            : Icons.warning_rounded,
                        size: 20, color: Colors.white,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _toast!,
                          style: GoogleFonts.sora(fontSize: 14, color: Colors.white),
                        ),
                      ),
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

class _DeptDropdown extends StatelessWidget {
  final String? value;
  final bool open;
  final String? error;
  final VoidCallback onToggle;
  final ValueChanged<String> onSelect;

  const _DeptDropdown({
    this.value,
    required this.open,
    this.error,
    required this.onToggle,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Departemen',
          style: GoogleFonts.sora(
            fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.t1,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onToggle,
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: error != null
                    ? AppColors.red
                    : open
                        ? AppColors.navy
                        : AppColors.border,
                width: (error != null || open) ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Icon(
                    Icons.business_outlined,
                    size: 16,
                    color: error != null
                        ? AppColors.red
                        : open
                            ? AppColors.navy
                            : AppColors.t3,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    value ?? 'Pilih departemen kamu',
                    style: GoogleFonts.sora(
                      fontSize: 14,
                      color: value != null ? AppColors.t1 : AppColors.t3,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Icon(
                    open ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    size: 18, color: AppColors.t3,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              error!,
              style: GoogleFonts.sora(fontSize: 11, color: AppColors.red),
            ),
          ),
        if (open)
          Container(
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1C2B4A).withValues(alpha: 0.10),
                  blurRadius: 24, offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: _kDepts.map((dept) {
                final selected = dept == value;
                return GestureDetector(
                  onTap: () => onSelect(dept),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.bg : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          dept,
                          style: GoogleFonts.sora(fontSize: 13, color: AppColors.t1),
                        ),
                        if (selected)
                          const Icon(Icons.check, size: 13, color: AppColors.amber),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
