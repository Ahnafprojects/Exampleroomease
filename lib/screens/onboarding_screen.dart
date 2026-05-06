import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _slide = 0;

  static const _slides = [
    _OnboardingSlide(
      title: 'Booking Tanpa Ribet',
      body: 'Pesan ruang meeting dalam hitungan detik. Pilih ruangan, waktu, dan fasilitas yang kamu butuhkan.',
      icon: Icons.calendar_today,
      iconColor: AppColors.amber,
      iconBg: Color(0x26F59E0B),
    ),
    _OnboardingSlide(
      title: 'Check-in Otomatis',
      body: 'Scan QR di pintu ruangan atau check-in manual. Ruangan otomatis dilepas jika tidak check-in dalam 15 menit.',
      icon: Icons.qr_code_scanner,
      iconColor: Colors.white,
      iconBg: Color(0x26FFFFFF),
    ),
    _OnboardingSlide(
      title: 'Data Utilisasi Lengkap',
      body: 'Admin GA punya laporan lengkap — utilisasi, ghost booking, peak hours, dan rekomendasi kapasitas.',
      icon: Icons.bar_chart,
      iconColor: AppColors.amber,
      iconBg: Color(0x26F59E0B),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final s = _slides[_slide];
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          // Illustration area
          Container(
            height: 420,
            decoration: const BoxDecoration(
              color: AppColors.navy,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 60,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                    ),
                  ),
                ),
                Positioned(
                  top: 100,
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                    ),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    key: ValueKey(_slide),
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      color: s.iconBg,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Icon(s.icon, size: 80, color: s.iconColor),
                  ),
                ),
              ],
            ),
          ),

          // Dots
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (i) {
              final isActive = i == _slide;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isActive ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.amber : const Color(0xFFD1D5DB),
                  borderRadius: BorderRadius.circular(99),
                ),
              );
            }),
          ),

          // Text
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Column(
                key: ValueKey(_slide),
                children: [
                  Text(s.title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.sora(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.t1)),
                  const SizedBox(height: 12),
                  Text(s.body,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.sora(fontSize: 14, color: AppColors.t2, height: 1.6)),
                ],
              ),
            ),
          ),

          const Spacer(),

          // Buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 48),
            child: _slide < 2
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pushReplacementNamed('/login'),
                        child: Text('Lewati', style: GoogleFonts.sora(fontSize: 14, color: AppColors.t3)),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _slide++),
                        child: Container(
                          width: 140,
                          height: 52,
                          decoration: BoxDecoration(
                            color: AppColors.amber,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Lanjut', style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward, size: 16, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : GestureDetector(
                    onTap: () => Navigator.of(context).pushReplacementNamed('/login'),
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.navy,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text('Mulai Sekarang', style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingSlide {
  final String title;
  final String body;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  const _OnboardingSlide({required this.title, required this.body, required this.icon, required this.iconColor, required this.iconBg});
}
