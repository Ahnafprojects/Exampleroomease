import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../theme.dart';
import 'room_card.dart';

class BookingCardH extends StatelessWidget {
  final Booking booking;
  final VoidCallback? onCheckin;

  const BookingCardH({super.key, required this.booking, this.onCheckin});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              RoomIconBlock(type: booking.roomType, size: 32),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  booking.roomName,
                  style: GoogleFonts.sora(fontSize: 15, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(children: [
            const Icon(Icons.access_time, size: 12, color: AppColors.t2),
            const SizedBox(width: 4),
            Text('${booking.time}–${booking.endTime}', style: GoogleFonts.sora(fontSize: 12, color: AppColors.t2)),
          ]),
          const SizedBox(height: 2),
          Row(children: [
            const Icon(Icons.location_on_outlined, size: 12, color: AppColors.t2),
            const SizedBox(width: 4),
            Text(booking.floor, style: GoogleFonts.sora(fontSize: 12, color: AppColors.t2)),
          ]),
          if (booking.status == BookingStatus.booked) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: onCheckin,
              child: Container(
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Center(
                  child: Text('Check-in Sekarang', style: GoogleFonts.sora(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
