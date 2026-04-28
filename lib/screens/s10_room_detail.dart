import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';
import '../data/mock_data.dart';

class RoomDetailScreen extends StatefulWidget {
  final Room room;
  const RoomDetailScreen({super.key, required this.room});

  @override
  State<RoomDetailScreen> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  bool _fav = false;

  static final _heroGradients = {
    RoomType.boardroom:   [const Color(0xFFDBEAFE), const Color(0xFF3B82F6)],
    RoomType.meetingRoom: [const Color(0xFFDCFCE7), const Color(0xFF22C55E)],
    RoomType.huddleSpace: [const Color(0xFFFFF7ED), const Color(0xFFF59E0B)],
    RoomType.training:    [const Color(0xFFF3E8FF), const Color(0xFFA855F7)],
  };

  @override
  Widget build(BuildContext context) {
    final room = widget.room;
    final grad = _heroGradients[room.type]!;
    final isMaint = room.status == RoomStatus.maintenance;
    final isFull  = room.status == RoomStatus.booked;
    final slots = AppData.timeSlots;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    // Hero
                    Container(
                      height: 224,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: grad,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Fade bottom
                          Positioned(
                            bottom: 0, left: 0, right: 0,
                            child: Container(
                              height: 80,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.transparent, AppColors.bg],
                                ),
                              ),
                            ),
                          ),
                          // Center icon
                          Center(
                            child: Container(
                              width: 72, height: 72,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                roomTypeCfg[room.type]!['icon'] as IconData,
                                size: 36,
                                color: roomTypeCfg[room.type]!['color'] as Color,
                              ),
                            ),
                          ),
                          if (isMaint)
                            Container(
                              color: Colors.black.withOpacity(0.4),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.build_outlined, size: 32, color: Colors.white),
                                    const SizedBox(height: 8),
                                    Text('Sedang Maintenance', style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                                    Text('Booking tidak tersedia sementara', style: GoogleFonts.sora(fontSize: 13, color: Colors.white70)),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Back button
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 8,
                      left: 16,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(color: Colors.black.withOpacity(0.35), shape: BoxShape.circle),
                          child: const Icon(Icons.arrow_back, size: 20, color: Colors.white),
                        ),
                      ),
                    ),
                    // Fav button
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 8,
                      right: 16,
                      child: GestureDetector(
                        onTap: () => setState(() => _fav = !_fav),
                        child: Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: _fav ? Colors.red.withOpacity(0.85) : Colors.black.withOpacity(0.35),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(_fav ? Icons.favorite : Icons.favorite_border, size: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Info card
                      Transform.translate(
                        offset: const Offset(0, -32),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: Text(room.name, style: GoogleFonts.sora(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.t1))),
                                  StatusPill(roomStatus: room.status),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(children: [const Icon(Icons.location_on_outlined, size: 14, color: AppColors.t2), const SizedBox(width: 4), Text('${room.floor} · ${room.building}', style: GoogleFonts.sora(fontSize: 13, color: AppColors.t2))]),
                              const SizedBox(height: 4),
                              Row(children: [const Icon(Icons.groups_outlined, size: 14, color: AppColors.t2), const SizedBox(width: 4), Text('Kapasitas ${room.capacity} orang', style: GoogleFonts.sora(fontSize: 13, color: AppColors.t2))]),
                              if (room.reviews > 0) ...[
                                const SizedBox(height: 4),
                                Row(children: [const Icon(Icons.star, size: 14, color: AppColors.amber), const SizedBox(width: 4), Text('${room.rating} · ${room.reviews} ulasan', style: GoogleFonts.sora(fontSize: 13, color: AppColors.t2))]),
                              ],
                              const Divider(height: 24),
                              Text('Fasilitas', style: GoogleFonts.sora(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.t1)),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8, runSpacing: 8,
                                children: room.facilities.map((f) => FacilityChip(label: f)).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Availability
                      Transform.translate(
                        offset: const Offset(0, -20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Ketersediaan Hari Ini', style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.t1)),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)],
                              ),
                              child: isFull
                                  ? Center(
                                      child: Column(
                                        children: [
                                          const Icon(Icons.cancel_outlined, size: 40, color: AppColors.red),
                                          const SizedBox(height: 8),
                                          Text('Semua slot penuh hari ini', style: GoogleFonts.sora(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.red)),
                                          Text('Coba tanggal lain', style: GoogleFonts.sora(fontSize: 13, color: AppColors.t2)),
                                          const SizedBox(height: 12),
                                          GestureDetector(
                                            onTap: () => Navigator.of(context).pushNamed('/calendar'),
                                            child: Container(
                                              height: 40, width: 140,
                                              decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(99)),
                                              child: Center(child: Text('Lihat Kalender', style: GoogleFonts.sora(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white))),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : GridView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        crossAxisSpacing: 8,
                                        mainAxisSpacing: 8,
                                        childAspectRatio: 2.2,
                                      ),
                                      itemCount: slots.length,
                                      itemBuilder: (_, i) {
                                        final slot = slots[i];
                                        final avail = slot['available'] as bool;
                                        return GestureDetector(
                                          onTap: avail && !isMaint
                                              ? () => Navigator.of(context).pushNamed('/booking-form', arguments: {'room': room, 'time': slot['time']})
                                              : null,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: avail && !isMaint ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                                              borderRadius: BorderRadius.circular(99),
                                            ),
                                            child: Center(
                                              child: Text(
                                                slot['time'] as String,
                                                style: GoogleFonts.sora(
                                                  fontSize: 12, fontWeight: FontWeight.w600,
                                                  color: avail && !isMaint ? AppColors.green : AppColors.red,
                                                  decoration: !avail ? TextDecoration.lineThrough : null,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bottom CTA
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, -4))],
              ),
              child: isMaint
                  ? Container(
                      height: 52,
                      decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(12)),
                      child: Center(child: Text('Tidak Tersedia', style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.t3))),
                    )
                  : isFull
                      ? Container(
                          height: 52,
                          decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(12)),
                          child: Center(child: Text('Semua Slot Penuh', style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.red))),
                        )
                      : GestureDetector(
                          onTap: () => Navigator.of(context).pushNamed('/booking-form', arguments: {'room': room}),
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(12)),
                            child: Center(child: Text('Booking Ruangan Ini', style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white))),
                          ),
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
