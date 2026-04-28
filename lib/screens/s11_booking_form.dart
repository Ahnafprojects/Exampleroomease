import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';
import '../data/mock_data.dart';

class BookingFormScreen extends StatefulWidget {
  final Room? room;
  final String? preTime;
  const BookingFormScreen({super.key, this.room, this.preTime});

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _kegunaanCtrl = TextEditingController();
  String? _selectedStartTime;
  String? _selectedEndTime;
  Room? _selectedRoom;
  bool _loading = false;

  static const _startTimes = ['08:00','08:30','09:00','09:30','10:00','10:30','11:00','11:30','12:00','13:00','13:30','14:00','14:30','15:00','15:30'];
  static const _endTimes   = ['08:30','09:00','09:30','10:00','10:30','11:00','11:30','12:00','13:00','13:30','14:00','14:30','15:00','15:30','16:00'];

  @override
  void initState() {
    super.initState();
    _selectedRoom = widget.room ?? AppData.rooms.first;
    _selectedStartTime = widget.preTime ?? '09:00';
    _selectedEndTime = '10:00';
  }

  @override
  void dispose() { _kegunaanCtrl.dispose(); super.dispose(); }

  void _submit() {
    if (_kegunaanCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.orange,
          content: Text('Isi keperluan terlebih dahulu', style: GoogleFonts.sora(color: Colors.white)),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    setState(() => _loading = true);
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      final newBooking = Booking(
        id: 'BK-NEW-${DateTime.now().millisecondsSinceEpoch}',
        roomId: _selectedRoom!.id,
        roomName: _selectedRoom!.name,
        roomType: _selectedRoom!.type,
        floor: _selectedRoom!.floor,
        date: 'Senin, 10 Mar 2026',
        dateShort: '10 Mar',
        time: _selectedStartTime!,
        endTime: _selectedEndTime!,
        duration: '1 jam',
        keperluan: _kegunaanCtrl.text,
        status: BookingStatus.booked,
        facilities: _selectedRoom!.facilities,
      );
      AppData.bookings.insert(0, newBooking);
      setState(() => _loading = false);
      Navigator.of(context).pushReplacementNamed('/booking-success', arguments: newBooking);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: RoomEaseAppBar(title: 'Form Booking'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Room picker
            Text('Pilih Ruangan', style: GoogleFonts.sora(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.t1)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Room>(
                  value: _selectedRoom,
                  isExpanded: true,
                  style: GoogleFonts.sora(fontSize: 14, color: AppColors.t1),
                  items: AppData.rooms.where((r) => r.status != RoomStatus.maintenance).map((r) {
                    return DropdownMenuItem(
                      value: r,
                      child: Row(
                        children: [
                          RoomIconBlock(type: r.type, size: 32),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(r.name, style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w500)),
                              Text('${r.capacity} orang · ${r.floor}', style: GoogleFonts.sora(fontSize: 11, color: AppColors.t2)),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (r) => setState(() => _selectedRoom = r),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Date (static for demo)
            _FormSection(label: 'Tanggal', child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.t2),
                  const SizedBox(width: 12),
                  Text('Senin, 10 Maret 2026', style: GoogleFonts.sora(fontSize: 14, color: AppColors.t1)),
                  const Spacer(),
                  const Icon(Icons.chevron_right, size: 16, color: AppColors.t3),
                ],
              ),
            )),
            const SizedBox(height: 20),

            // Time pickers
            Row(
              children: [
                Expanded(child: _FormSection(label: 'Mulai', child: _TimeDropdown(
                  value: _selectedStartTime,
                  items: _startTimes,
                  onChanged: (v) => setState(() => _selectedStartTime = v),
                ))),
                const SizedBox(width: 12),
                Expanded(child: _FormSection(label: 'Selesai', child: _TimeDropdown(
                  value: _selectedEndTime,
                  items: _endTimes,
                  onChanged: (v) => setState(() => _selectedEndTime = v),
                ))),
              ],
            ),
            const SizedBox(height: 20),

            // Keperluan
            AppInputField(
              label: 'Keperluan',
              placeholder: 'Contoh: Sprint Planning Tim Backend',
              controller: _kegunaanCtrl,
              leftIcon: Icons.info_outline,
            ),
            const SizedBox(height: 32),

            // Summary card
            if (_selectedRoom != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFBFDBFE)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ringkasan Booking', style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.navy)),
                    const SizedBox(height: 8),
                    _SummaryRow('Ruangan', _selectedRoom!.name),
                    _SummaryRow('Lantai', _selectedRoom!.floor),
                    _SummaryRow('Tanggal', '10 Mar 2026'),
                    _SummaryRow('Waktu', '${_selectedStartTime ?? '-'}–${_selectedEndTime ?? '-'}'),
                  ],
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, -4))],
        ),
        child: PrimaryButton(label: 'Konfirmasi Booking', onTap: _submit, loading: _loading),
      ),
    );
  }
}

class _FormSection extends StatelessWidget {
  final String label;
  final Widget child;
  const _FormSection({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.sora(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.t1)),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _TimeDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  const _TimeDropdown({required this.value, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          style: GoogleFonts.sora(fontSize: 14, color: AppColors.t1),
          items: items.map((t) => DropdownMenuItem(value: t, child: Text(t, style: GoogleFonts.sora(fontSize: 14)))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(label, style: GoogleFonts.sora(fontSize: 12, color: AppColors.t2))),
          Text(': ', style: GoogleFonts.sora(fontSize: 12, color: AppColors.t2)),
          Expanded(child: Text(value, style: GoogleFonts.sora(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.navy))),
        ],
      ),
    );
  }
}
