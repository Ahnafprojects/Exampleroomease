import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

class BookingSuccessScreen extends StatefulWidget {
  final Booking booking;
  const BookingSuccessScreen({super.key, required this.booking});

  @override
  State<BookingSuccessScreen> createState() => _BookingSuccessScreenState();
}

class _BookingSuccessScreenState extends State<BookingSuccessScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _scaleAnim = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final b = widget.booking;
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Spacer(),
              ScaleTransition(
                scale: _scaleAnim,
                child: Container(
                  width: 120, height: 120,
                  decoration: BoxDecoration(color: AppColors.availableBg, shape: BoxShape.circle),
                  child: const Icon(Icons.check_circle_outline, size: 64, color: AppColors.green),
                ),
              ),
              const SizedBox(height: 24),
              Text('Booking Berhasil!', style: GoogleFonts.sora(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.t1)),
              const SizedBox(height: 8),
              Text('Ruangan berhasil dipesan. Ingat untuk check-in tepat waktu!',
                textAlign: TextAlign.center,
                style: GoogleFonts.sora(fontSize: 14, color: AppColors.t2, height: 1.5)),
              const SizedBox(height: 32),

              // Booking detail card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 4))],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        RoomIconBlock(type: b.roomType, size: 48),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(b.roomName, style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w700)),
                              Text(b.floor, style: GoogleFonts.sora(fontSize: 13, color: AppColors.t2)),
                            ],
                          ),
                        ),
                        StatusPill(bookingStatus: BookingStatus.booked),
                      ],
                    ),
                    const Divider(height: 24),
                    _DetailRow(icon: Icons.calendar_today_outlined, text: b.date),
                    const SizedBox(height: 8),
                    _DetailRow(icon: Icons.access_time, text: '${b.time}–${b.endTime} (${b.duration})'),
                    const SizedBox(height: 8),
                    _DetailRow(icon: Icons.info_outline, text: b.keperluan),
                    const SizedBox(height: 8),
                    _DetailRow(icon: Icons.confirmation_number_outlined, text: b.id),
                  ],
                ),
              ),
              const Spacer(),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pushReplacementNamed('/main'),
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(child: Text('Beranda', style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.t2))),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pushReplacementNamed('/checkin', arguments: b),
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(12)),
                        child: Center(child: Text('Check-in Sekarang', style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white))),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _DetailRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.t2),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: GoogleFonts.sora(fontSize: 13, color: AppColors.t1))),
      ],
    );
  }
}
