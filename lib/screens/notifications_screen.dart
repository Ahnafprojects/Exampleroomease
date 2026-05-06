import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../models/models.dart';
import '../data/mock_data.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    final notifs = AppData.notifications;
    final today = notifs.where((n) => n.group == 'today').toList();
    final yesterday = notifs.where((n) => n.group == 'yesterday').toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text('Notifikasi', style: GoogleFonts.sora(fontSize: 17, fontWeight: FontWeight.w600)),
        actions: [
          TextButton(
            onPressed: () => setState(() { for (final n in notifs) { n.read = true; } }),
            child: Text('Tandai semua dibaca', style: GoogleFonts.sora(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.amber)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
        children: [
          if (today.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text('Hari Ini', style: GoogleFonts.sora(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.t2)),
            ),
            ...today.map((n) => _NotifCard(notif: n, onRead: () => setState(() => n.read = true))),
          ],
          if (yesterday.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Text('Kemarin', style: GoogleFonts.sora(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.t2)),
            ),
            ...yesterday.map((n) => _NotifCard(notif: n, onRead: () => setState(() => n.read = true))),
          ],
          if (notifs.isEmpty)
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  const Icon(Icons.notifications_off_outlined, size: 64, color: Color(0xFFD1D5DB)),
                  const SizedBox(height: 12),
                  Text('Tidak ada notifikasi', style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.t1)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _NotifCard extends StatelessWidget {
  final NotificationItem notif;
  final VoidCallback onRead;

  const _NotifCard({required this.notif, required this.onRead});

  static const _typeCfg = {
    1: {'bg': Color(0xFFFEF3C7), 'icon': Icons.access_alarm, 'color': Color(0xFFD97706)},
    2: {'bg': Color(0xFFDCFCE7), 'icon': Icons.check_circle_outline, 'color': Color(0xFF16A34A)},
    3: {'bg': Color(0xFFFEE2E2), 'icon': Icons.warning_amber_outlined, 'color': Color(0xFFDC2626)},
    4: {'bg': Color(0xFFF3F4F6), 'icon': Icons.cancel_outlined, 'color': Color(0xFF6B7280)},
  };

  @override
  Widget build(BuildContext context) {
    final cfg = _typeCfg[notif.type] ?? _typeCfg[1]!;
    return GestureDetector(
      onTap: onRead,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notif.read ? Colors.white : const Color(0xFFFFF8ED),
          borderRadius: BorderRadius.circular(16),
          border: notif.read ? null : Border.all(color: AppColors.amber.withValues(alpha: 0.3)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(color: cfg['bg'] as Color, shape: BoxShape.circle),
              child: Icon(cfg['icon'] as IconData, size: 20, color: cfg['color'] as Color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notif.title, style: GoogleFonts.sora(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.t1)),
                  const SizedBox(height: 2),
                  Text(notif.body, style: GoogleFonts.sora(fontSize: 12, color: AppColors.t2, height: 1.4)),
                  const SizedBox(height: 4),
                  Text(notif.time, style: GoogleFonts.sora(fontSize: 11, color: AppColors.t3)),
                ],
              ),
            ),
            if (!notif.read)
              Container(
                width: 8, height: 8, margin: const EdgeInsets.only(top: 4),
                decoration: const BoxDecoration(color: AppColors.amber, shape: BoxShape.circle),
              ),
          ],
        ),
      ),
    );
  }
}
