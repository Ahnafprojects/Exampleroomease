import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../widgets/widgets.dart';
import '../models/models.dart';
import '../data/mock_data.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final upcoming = AppData.bookings.where((b) => b.status == BookingStatus.booked || b.status == BookingStatus.checkedin).toList();
    final history = AppData.bookings.where((b) => b.status == BookingStatus.done || b.status == BookingStatus.cancelled || b.status == BookingStatus.noshow).toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text('Booking Saya', style: GoogleFonts.sora(fontSize: 17, fontWeight: FontWeight.w600)),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tab,
          labelStyle: GoogleFonts.sora(fontWeight: FontWeight.w600, fontSize: 14),
          unselectedLabelStyle: GoogleFonts.sora(fontWeight: FontWeight.w400, fontSize: 14),
          labelColor: AppColors.navy,
          unselectedLabelColor: AppColors.t2,
          indicatorColor: AppColors.navy,
          tabs: const [Tab(text: 'Aktif'), Tab(text: 'Riwayat')],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _BookingList(bookings: upcoming, isUpcoming: true),
          _BookingList(bookings: history, isUpcoming: false),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).pushNamed('/rooms'),
        backgroundColor: AppColors.navy,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('Booking Baru', style: GoogleFonts.sora(fontWeight: FontWeight.w600, color: Colors.white)),
      ),
    );
  }
}

class _BookingList extends StatelessWidget {
  final List<Booking> bookings;
  final bool isUpcoming;

  const _BookingList({required this.bookings, required this.isUpcoming});

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calendar_today_outlined, size: 64, color: Color(0xFFD1D5DB)),
            const SizedBox(height: 12),
            Text(isUpcoming ? 'Belum ada booking aktif' : 'Belum ada riwayat',
              style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.t1)),
            Text('Mulai booking ruangan sekarang!',
              style: GoogleFonts.sora(fontSize: 13, color: AppColors.t2)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      itemCount: bookings.length,
      itemBuilder: (_, i) => _BookingCard(booking: bookings[i], isUpcoming: isUpcoming),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final Booking booking;
  final bool isUpcoming;

  const _BookingCard({required this.booking, required this.isUpcoming});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              RoomIconBlock(type: booking.roomType, size: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(booking.roomName, style: GoogleFonts.sora(fontSize: 15, fontWeight: FontWeight.w600)),
                    Text(booking.floor, style: GoogleFonts.sora(fontSize: 13, color: AppColors.t2)),
                  ],
                ),
              ),
              StatusPill(bookingStatus: booking.status),
            ],
          ),
          const SizedBox(height: 12),
          _InfoRow(icon: Icons.calendar_today_outlined, text: booking.date),
          const SizedBox(height: 4),
          _InfoRow(icon: Icons.access_time, text: '${booking.time}–${booking.endTime} (${booking.duration})'),
          const SizedBox(height: 4),
          _InfoRow(icon: Icons.info_outline, text: booking.keperluan),

          if (booking.facilities.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: booking.facilities.map((f) => FacilityChip(label: f)).toList(),
            ),
          ],

          if (isUpcoming) ...[
            const Divider(height: 24),
            Row(
              children: [
                if (booking.status == BookingStatus.booked)
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed('/checkin', arguments: booking),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(99)),
                        child: Center(child: Text('Check-in Sekarang', style: GoogleFonts.sora(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white))),
                      ),
                    ),
                  ),
                if (booking.status == BookingStatus.checkedin)
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(color: AppColors.checkedinBg, borderRadius: BorderRadius.circular(99)),
                      child: Center(child: Text('Sedang Check-in', style: GoogleFonts.sora(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.checkedinText))),
                    ),
                  ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _showCancelDialog(context, booking),
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Center(child: Text('Batalkan', style: GoogleFonts.sora(fontSize: 13, color: AppColors.t2))),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context, Booking booking) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(99))),
            const SizedBox(height: 24),
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(color: AppColors.bookedBg, shape: BoxShape.circle),
              child: const Icon(Icons.cancel_outlined, size: 32, color: AppColors.red),
            ),
            const SizedBox(height: 16),
            Text('Batalkan Booking?', style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.t1)),
            const SizedBox(height: 8),
            Text('Tindakan ini tidak dapat diurungkan. Slot waktu akan dilepas.',
              textAlign: TextAlign.center,
              style: GoogleFonts.sora(fontSize: 13, color: AppColors.t2, height: 1.5)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(12)),
                      child: Center(child: Text('Tidak', style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.t2))),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      booking.status = BookingStatus.cancelled;
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.navy,
                          content: Text('Booking dibatalkan', style: GoogleFonts.sora(color: Colors.white)),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    },
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(color: AppColors.red, borderRadius: BorderRadius.circular(12)),
                      child: Center(child: Text('Ya, Batalkan', style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white))),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.t2),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: GoogleFonts.sora(fontSize: 13, color: AppColors.t2))),
      ],
    );
  }
}
