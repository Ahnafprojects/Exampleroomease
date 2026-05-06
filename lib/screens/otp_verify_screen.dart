import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../widgets/widgets.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String email;

  const OtpVerifyScreen({super.key, required this.email});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final List<TextEditingController> _ctrls =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _nodes = List.generate(6, (_) => FocusNode());

  bool _loading = false;
  bool _toastVisible = false;
  String? _toast;
  bool _toastSuccess = false;

  int _resendSeconds = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _resendSeconds = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_resendSeconds <= 0) {
        t.cancel();
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  String get _otp => _ctrls.map((c) => c.text).join();

  void _showToast(String msg, {bool success = false}) {
    setState(() { _toast = msg; _toastVisible = true; _toastSuccess = success; });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _toastVisible = false);
    });
  }

  void _onChanged(String val, int index) {
    if (val.length == 1 && index < 5) {
      _nodes[index + 1].requestFocus();
    } else if (val.isEmpty && index > 0) {
      _nodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  void _handleVerify() {
    if (_otp.length < 6) {
      _showToast('Masukkan 6 digit kode OTP');
      return;
    }
    setState(() => _loading = true);
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() => _loading = false);
      if (_otp == '000000') {
        _showToast('Kode OTP tidak valid. Coba lagi.');
        return;
      }
      _showToast('Email berhasil diverifikasi!', success: true);
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) Navigator.of(context).pushReplacementNamed('/main');
      });
    });
  }

  void _handleResend() {
    if (_resendSeconds > 0) return;
    for (final c in _ctrls) { c.clear(); }
    _nodes[0].requestFocus();
    _startTimer();
    _showToast('Kode OTP baru telah dikirim ke email kamu.');
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _ctrls) { c.dispose(); }
    for (final n in _nodes) { n.dispose(); }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          // Navy hero (shorter — 200px)
          Positioned(
            top: 0, left: 0, right: 0,
            height: 200 + top,
            child: Container(
              color: AppColors.navy,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    right: -80, top: -40 + top,
                    child: Container(
                      width: 200, height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.amber.withValues(alpha: 0.18)),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20, top: 60 + top,
                    child: Container(
                      width: 50, height: 50,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.amber,
                      ),
                    ),
                  ),
                  // Back button
                  Positioned(
                    left: 20, top: 16 + top,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.arrow_back, size: 20, color: Colors.white),
                      ),
                    ),
                  ),
                  // Title
                  Positioned(
                    left: 24, right: 24,
                    bottom: 32 + 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'VERIFIKASI EMAIL',
                          style: GoogleFonts.sora(
                            fontSize: 11, fontWeight: FontWeight.w600,
                            color: AppColors.amber, letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Cek kode\nmasuk kamu.',
                          style: GoogleFonts.sora(
                            fontSize: 26, fontWeight: FontWeight.w700,
                            color: Colors.white, height: 1.2, letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // White lifted card
          Positioned(
            top: 200 + top - 32,
            left: 0, right: 0, bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1C2B4A).withValues(alpha: 0.08),
                    blurRadius: 32, offset: const Offset(0, -8),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Email info
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.bg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.mail_outline, size: 18, color: AppColors.navy),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Kode dikirim ke',
                                  style: GoogleFonts.sora(fontSize: 11, color: AppColors.t3),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  widget.email,
                                  style: GoogleFonts.sora(
                                    fontSize: 13, fontWeight: FontWeight.w600,
                                    color: AppColors.t1,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    Text(
                      'Kode OTP',
                      style: GoogleFonts.sora(
                        fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.t1,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // OTP boxes
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, (i) => _OtpBox(
                        controller: _ctrls[i],
                        focusNode: _nodes[i],
                        onChanged: (v) => _onChanged(v, i),
                        onKeyBackspace: () {
                          if (_ctrls[i].text.isEmpty && i > 0) {
                            _nodes[i - 1].requestFocus();
                            _ctrls[i - 1].clear();
                          }
                        },
                      )),
                    ),

                    const SizedBox(height: 28),

                    AuthCTAButton(
                      label: 'Verifikasi',
                      loading: _loading,
                      onTap: _handleVerify,
                    ),

                    const SizedBox(height: 24),

                    // Resend
                    Center(
                      child: _resendSeconds > 0
                          ? RichText(
                              text: TextSpan(
                                style: GoogleFonts.sora(fontSize: 13, color: AppColors.t2),
                                children: [
                                  const TextSpan(text: 'Kirim ulang kode dalam '),
                                  TextSpan(
                                    text: '${_resendSeconds}s',
                                    style: GoogleFonts.sora(
                                      fontSize: 13, fontWeight: FontWeight.w600,
                                      color: AppColors.navy,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : GestureDetector(
                              onTap: _handleResend,
                              child: RichText(
                                text: TextSpan(
                                  style: GoogleFonts.sora(fontSize: 13, color: AppColors.t2),
                                  children: [
                                    const TextSpan(text: 'Tidak terima kode? '),
                                    TextSpan(
                                      text: 'Kirim ulang',
                                      style: GoogleFonts.sora(
                                        fontSize: 13, fontWeight: FontWeight.w600,
                                        color: AppColors.amber,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Toast
          if (_toastVisible && _toast != null)
            Positioned(
              top: top + 16,
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
                        _toastSuccess ? Icons.check_circle_outline : Icons.warning_rounded,
                        size: 20, color: Colors.white,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _toast!,
                          style: GoogleFonts.sora(fontSize: 13, color: Colors.white),
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

class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onKeyBackspace;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onKeyBackspace,
  });

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.backspace &&
            controller.text.isEmpty) {
          onKeyBackspace();
        }
      },
      child: SizedBox(
        width: 46,
        height: 56,
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: onChanged,
          style: GoogleFonts.sora(
            fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.navy,
          ),
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: focusNode.hasFocus ? AppColors.bg : Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: controller.text.isNotEmpty ? AppColors.navy : AppColors.border,
                width: controller.text.isNotEmpty ? 2 : 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.navy, width: 2),
            ),
          ),
        ),
      ),
    );
  }
}
