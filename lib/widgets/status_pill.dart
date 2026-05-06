import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../theme.dart';

class StatusPill extends StatelessWidget {
  final BookingStatus? bookingStatus;
  final RoomStatus? roomStatus;

  const StatusPill({super.key, this.bookingStatus, this.roomStatus});

  @override
  Widget build(BuildContext context) {
    Color bg, text, dot;
    String label;

    if (bookingStatus != null) {
      switch (bookingStatus!) {
        case BookingStatus.booked:
          bg = AppColors.bookedBg; text = AppColors.bookedText; dot = AppColors.red; label = 'Upcoming';
        case BookingStatus.checkedin:
          bg = AppColors.checkedinBg; text = AppColors.checkedinText; dot = AppColors.orange; label = 'Check-in';
        case BookingStatus.done:
          bg = AppColors.doneBg; text = AppColors.doneText; dot = AppColors.t3; label = 'Selesai';
        case BookingStatus.cancelled:
          bg = AppColors.doneBg; text = AppColors.doneText; dot = AppColors.red; label = 'Dibatalkan';
        case BookingStatus.noshow:
          bg = AppColors.bookedBg; text = AppColors.bookedText; dot = AppColors.red; label = 'No-show';
      }
    } else {
      switch (roomStatus!) {
        case RoomStatus.available:
          bg = AppColors.availableBg; text = AppColors.availableText; dot = AppColors.green; label = 'Tersedia';
        case RoomStatus.booked:
          bg = AppColors.bookedBg; text = AppColors.bookedText; dot = AppColors.red; label = 'Penuh';
        case RoomStatus.checkedin:
          bg = AppColors.checkedinBg; text = AppColors.checkedinText; dot = AppColors.orange; label = 'Check-in';
        case RoomStatus.maintenance:
          bg = AppColors.maintenanceBg; text = AppColors.maintenanceText; dot = const Color(0xFF94A3B8); label = 'Maintenance';
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(99)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 6, height: 6, decoration: BoxDecoration(color: dot, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(label, style: GoogleFonts.sora(fontSize: 11, fontWeight: FontWeight.w600, color: text)),
        ],
      ),
    );
  }
}

class FacilityChip extends StatelessWidget {
  final String label;
  const FacilityChip({super.key, required this.label});

  static const _icons = {
    'TV': Icons.tv,
    'Projector': Icons.videocam_outlined,
    'Speaker': Icons.volume_up_outlined,
    'WiFi': Icons.wifi,
    'Whiteboard': Icons.edit_outlined,
    'Video Call': Icons.video_call_outlined,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_icons[label] != null) ...[
            Icon(_icons[label]!, size: 14, color: AppColors.t2),
            const SizedBox(width: 4),
          ],
          Text(label, style: GoogleFonts.sora(fontSize: 13, color: AppColors.t2)),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const SectionHeader({super.key, required this.title, this.action, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.w600)),
          if (action != null)
            GestureDetector(
              onTap: onAction,
              child: Text(action!, style: GoogleFonts.sora(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.amber)),
            ),
        ],
      ),
    );
  }
}
