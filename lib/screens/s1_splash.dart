import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
    _progress = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
    _ctrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            Navigator.of(context).pushReplacementNamed('/onboarding');
          }
        });
      }
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.amber,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.business, size: 40, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text('RoomEase', style: GoogleFonts.sora(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white)),
                const SizedBox(height: 8),
                Text('Booking ruangan jadi mudah', style: GoogleFonts.sora(fontSize: 14, color: const Color(0xFF93A8C8))),
              ],
            ),
          ),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                AnimatedBuilder(
                  animation: _progress,
                  builder: (_, __) => SizedBox(
                    width: 120,
                    child: LinearProgressIndicator(
                      value: _progress.value,
                      minHeight: 4,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.amber),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
