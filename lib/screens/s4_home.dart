import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../widgets/widgets.dart';
import '../models/models.dart';
import '../data/mock_data.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onNotifTap;
  final ValueChanged<int> onTabChange;
  final int notifCount;

  const HomeScreen({
    super.key,
    required this.onNotifTap,
    required this.onTabChange,
    required this.notifCount,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final rooms = AppData.rooms;
    final availableRooms = rooms.where((r) => r.status == RoomStatus.available).toList();
    final upcomingBookings = AppData.bookings
        .where((b) => b.status == BookingStatus.booked || b.status == BookingStatus.checkedin)
        .toList();
    final doneToday = AppData.bookings.where((b) => b.status == BookingStatus.done).length;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: [
          // Hero Header
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Senin, 10 Mar 2026', style: GoogleFonts.sora(fontSize: 11, color: const Color(0xFF93A8C8))),
                          GestureDetector(
                            onTap: widget.onNotifTap,
                            child: Stack(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.notifications_outlined, size: 20, color: Colors.white),
                                ),
                                if (widget.notifCount > 0)
                                  Positioned(
                                    top: 0, right: 0,
                                    child: Container(
                                      width: 8, height: 8,
                                      decoration: BoxDecoration(
                                        color: AppColors.amber,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: AppColors.navy, width: 1.5),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(AppData.getGreeting(), style: GoogleFonts.sora(fontSize: 13, color: const Color(0xFF93A8C8))),
                      const SizedBox(height: 2),
                      Text(AppData.user.name, style: GoogleFonts.sora(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF4ADE80), shape: BoxShape.circle)),
                            const SizedBox(width: 8),
                            Text('${availableRooms.length} ruangan tersedia sekarang',
                              style: GoogleFonts.sora(fontSize: 12, color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -24),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _StatCard(
                      value: '${upcomingBookings.length}',
                      label: 'Booking Aktif',
                      onTap: () => widget.onTabChange(1),
                    ),
                    const SizedBox(width: 8),
                    _StatCard(
                      value: '${availableRooms.length}',
                      label: 'Tersedia',
                      onTap: () => widget.onTabChange(1),
                    ),
                    const SizedBox(width: 8),
                    _StatCard(
                      value: '$doneToday',
                      label: 'Selesai Hari Ini',
                      onTap: () => widget.onTabChange(1),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Booking Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: SectionHeader(
                title: 'Booking Saya',
                action: 'Lihat Semua',
                onAction: () => widget.onTabChange(1),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: _loading
                ? SizedBox(
                    height: 140,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: 2,
                      itemBuilder: (_, __) => Container(
                        width: 240, margin: const EdgeInsets.only(right: 12),
                        child: const SkeletonStatCard(),
                      ),
                    ),
                  )
                : upcomingBookings.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            const Icon(Icons.calendar_today_outlined, size: 64, color: Color(0xFFD1D5DB)),
                            const SizedBox(height: 12),
                            Text('Belum ada booking aktif', style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.t1)),
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: () => widget.onTabChange(1),
                              child: Container(
                                height: 44, width: 160,
                                decoration: BoxDecoration(color: AppColors.amber, borderRadius: BorderRadius.circular(12)),
                                child: Center(child: Text('Booking Sekarang', style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white))),
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(
                        height: 140,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: upcomingBookings.length,
                          itemBuilder: (_, i) => Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: BookingCardH(
                              booking: upcomingBookings[i],
                              onCheckin: () => Navigator.of(context).pushNamed('/checkin', arguments: upcomingBookings[i]),
                            ),
                          ),
                        ),
                      ),
          ),

          // Rooms Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: SectionHeader(
                title: 'Ruangan Tersedia',
                action: 'Semua',
                onAction: () => Navigator.of(context).pushNamed('/rooms'),
              ),
            ),
          ),

          if (_loading)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, __) => const SkeletonRoomCard(),
                  childCount: 3,
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) {
                    final r = rooms.where((r) => r.status != RoomStatus.maintenance).toList()[i];
                    return RoomCard(
                      room: r,
                      onTap: () => Navigator.of(context).pushNamed('/room-detail', arguments: r),
                    );
                  },
                  childCount: rooms.where((r) => r.status != RoomStatus.maintenance).take(3).length,
                ),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final VoidCallback? onTap;

  const _StatCard({required this.value, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 16, offset: const Offset(0, 4))],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(value, style: GoogleFonts.sora(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.navy)),
              const SizedBox(height: 4),
              Text(label, textAlign: TextAlign.center, style: GoogleFonts.sora(fontSize: 11, color: AppColors.t2, height: 1.3)),
            ],
          ),
        ),
      ),
    );
  }
}
