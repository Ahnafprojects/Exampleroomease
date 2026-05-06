import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

class CheckInScreen extends StatefulWidget {
  final Booking booking;
  const CheckInScreen({super.key, required this.booking});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  String _state = 'waiting'; // waiting | checked | released
  int _seconds = 12 * 60 + 45;
  bool _loadingManual = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      if (_seconds <= 0) { t.cancel(); setState(() => _state = 'released'); return; }
      setState(() => _seconds--);
    });
  }

  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  String get _mm => (_seconds ~/ 60).toString().padLeft(2, '0');
  String get _ss => (_seconds % 60).toString().padLeft(2, '0');
  double get _pct => _seconds / (15 * 60);
  bool get _isLow => _seconds <= 60;

  void _handleManualCheckin() {
    setState(() => _loadingManual = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      _timer?.cancel();
      widget.booking.status = BookingStatus.checkedin;
      setState(() { _loadingManual = false; _state = 'checked'; });
    });
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: RoomEaseAppBar(title: 'Check-In', onLeft: () => Navigator.pop(context)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Booking summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12)],
              ),
              child: Row(
                children: [
                  RoomIconBlock(type: booking.roomType, size: 56),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(booking.roomName, style: GoogleFonts.sora(fontSize: 15, fontWeight: FontWeight.w600)),
                        Text('${booking.floor} · Gedung Utama', style: GoogleFonts.sora(fontSize: 13, color: AppColors.t2)),
                        const SizedBox(height: 4),
                        Row(children: [
                          const Icon(Icons.access_time, size: 12, color: AppColors.t2),
                          const SizedBox(width: 4),
                          Text('${booking.time}–${booking.endTime}', style: GoogleFonts.sora(fontSize: 12, color: AppColors.t2)),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Status card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12)],
              ),
              child: _state == 'waiting' ? _buildWaiting() : _state == 'checked' ? _buildChecked() : _buildReleased(),
            ),

            if (_state == 'waiting') ...[
              const SizedBox(height: 20),
              // QR scan option
              GestureDetector(
                onTap: () => Navigator.of(context).pushNamed('/qr-scan'),
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
                      const Icon(Icons.qr_code_scanner, size: 20, color: AppColors.navy),
                      const SizedBox(width: 8),
                      Text('Scan QR Code di Pintu', style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.navy)),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWaiting() {
    return Column(
      children: [
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(color: AppColors.checkedinBg, shape: BoxShape.circle),
          child: const Icon(Icons.access_time, size: 40, color: AppColors.orange),
        ),
        const SizedBox(height: 16),
        Text('Menunggu Check-In', style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.w600)),
        Text('Hadir sebelum waktu habis', style: GoogleFonts.sora(fontSize: 13, color: AppColors.t2)),
        const SizedBox(height: 24),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 500),
          style: GoogleFonts.sora(
            fontSize: 44,
            fontWeight: FontWeight.w700,
            color: _isLow ? AppColors.red : AppColors.navy,
          ),
          child: Text('$_mm:$_ss'),
        ),
        Text('sisa waktu check-in', style: GoogleFonts.sora(fontSize: 11, color: AppColors.t3)),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            value: _pct,
            minHeight: 8,
            backgroundColor: const Color(0xFFF3F4F6),
            valueColor: AlwaysStoppedAnimation<Color>(_isLow ? AppColors.red : AppColors.amber),
          ),
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: _handleManualCheckin,
          child: Container(
            width: double.infinity, height: 52,
            decoration: BoxDecoration(
              color: _loadingManual ? AppColors.navy.withValues(alpha: 0.8) : AppColors.navy,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: _loadingManual
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle_outline, size: 18, color: Colors.white),
                        const SizedBox(width: 8),
                        Text('Check-in Manual', style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChecked() {
    return Column(
      children: [
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(color: AppColors.availableBg, shape: BoxShape.circle),
          child: const Icon(Icons.check_circle_outline, size: 40, color: AppColors.green),
        ),
        const SizedBox(height: 16),
        Text('Check-in Berhasil!', style: GoogleFonts.sora(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.green)),
        const SizedBox(height: 8),
        Text('Ruangan siap digunakan. Selamat bekerja!', textAlign: TextAlign.center, style: GoogleFonts.sora(fontSize: 13, color: AppColors.t2)),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: double.infinity, height: 52,
            decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text('Kembali ke Beranda', style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white))),
          ),
        ),
      ],
    );
  }

  Widget _buildReleased() {
    return Column(
      children: [
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(color: AppColors.bookedBg, shape: BoxShape.circle),
          child: const Icon(Icons.timer_off_outlined, size: 40, color: AppColors.red),
        ),
        const SizedBox(height: 16),
        Text('Waktu Habis', style: GoogleFonts.sora(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.red)),
        const SizedBox(height: 8),
        Text('Booking otomatis dibatalkan karena tidak ada check-in.', textAlign: TextAlign.center, style: GoogleFonts.sora(fontSize: 13, color: AppColors.t2)),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: () => Navigator.of(context).pushReplacementNamed('/rooms'),
          child: Container(
            width: double.infinity, height: 52,
            decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text('Booking Ulang', style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white))),
          ),
        ),
      ],
    );
  }
}
