import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

class BottomNav extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onTap;
  final bool isAdmin;

  const BottomNav({super.key, required this.activeIndex, required this.onTap, this.isAdmin = false});

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Beranda'),
      _NavItem(icon: Icons.calendar_today_outlined, activeIcon: Icons.calendar_today, label: 'Booking'),
      _NavItem(icon: Icons.date_range_outlined, activeIcon: Icons.date_range, label: 'Kalender'),
      if (isAdmin)
        _NavItem(icon: Icons.bar_chart_outlined, activeIcon: Icons.bar_chart, label: 'Laporan'),
      _NavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profil'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, -4))],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            children: items.asMap().entries.map((e) {
              final i = e.key;
              final item = e.value;
              final isActive = activeIndex == i;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isActive ? item.activeIcon : item.icon,
                        size: 24,
                        color: isActive ? AppColors.navy : AppColors.t3,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: GoogleFonts.sora(
                          fontSize: 10,
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                          color: isActive ? AppColors.navy : AppColors.t3,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem({required this.icon, required this.activeIcon, required this.label});
}
