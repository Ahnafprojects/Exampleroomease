import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

class AuthShell extends StatelessWidget {
  final bool isLogin;
  final VoidCallback? onSwitchToLogin;
  final VoidCallback? onSwitchToRegister;
  final Widget child;

  const AuthShell({
    super.key,
    required this.isLogin,
    this.onSwitchToLogin,
    this.onSwitchToRegister,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    const navyH = 240.0;
    const overlap = 32.0;

    return Stack(
      children: [
        Positioned(
          top: 0, left: 0, right: 0,
          height: navyH + top,
          child: Container(
            color: AppColors.navy,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  right: -120, top: -60 + top,
                  child: Container(
                    width: 280, height: 280,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.amber.withValues(alpha: 0.18)),
                    ),
                  ),
                ),
                Positioned(
                  right: -40, top: 30 + top,
                  child: Container(
                    width: 160, height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.amber.withValues(alpha: 0.30)),
                    ),
                  ),
                ),
                Positioned(
                  right: 30, top: 90 + top,
                  child: Container(
                    width: 60, height: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.amber,
                    ),
                  ),
                ),
                Positioned(
                  left: 24, top: 64 + top,
                  child: Row(
                    children: [
                      Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.amber,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.business, size: 20, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'RoomEase',
                        style: GoogleFonts.sora(
                          fontSize: 15, fontWeight: FontWeight.w600,
                          color: Colors.white, letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 24, right: 24,
                  bottom: overlap + 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isLogin ? 'MASUK AKUN' : 'BUAT AKUN',
                        style: GoogleFonts.sora(
                          fontSize: 11, fontWeight: FontWeight.w600,
                          color: AppColors.amber, letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isLogin ? 'Selamat datang\nkembali.' : 'Bergabung\ndengan tim.',
                        style: GoogleFonts.sora(
                          fontSize: 28, fontWeight: FontWeight.w700,
                          color: Colors.white, height: 1.15, letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: navyH + top - overlap,
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: _AuthSegmentedTabs(
                    isLogin: isLogin,
                    onSwitchToLogin: onSwitchToLogin,
                    onSwitchToRegister: onSwitchToRegister,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AuthSegmentedTabs extends StatelessWidget {
  final bool isLogin;
  final VoidCallback? onSwitchToLogin;
  final VoidCallback? onSwitchToRegister;

  const _AuthSegmentedTabs({
    required this.isLogin,
    this.onSwitchToLogin,
    this.onSwitchToRegister,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: isLogin ? Alignment.centerLeft : Alignment.centerRight,
            duration: const Duration(milliseconds: 280),
            curve: const Cubic(0.2, 0.8, 0.2, 1),
            child: FractionallySizedBox(
              widthFactor: 0.5,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1C2B4A).withValues(alpha: 0.10),
                      blurRadius: 6, offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: !isLogin ? onSwitchToLogin : null,
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Text(
                      'Masuk',
                      style: GoogleFonts.sora(
                        fontSize: 13, fontWeight: FontWeight.w600,
                        color: isLogin ? AppColors.navy : AppColors.t3,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: isLogin ? onSwitchToRegister : null,
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Text(
                      'Daftar',
                      style: GoogleFonts.sora(
                        fontSize: 13, fontWeight: FontWeight.w600,
                        color: !isLogin ? AppColors.navy : AppColors.t3,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
