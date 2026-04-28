import 'package:flutter/material.dart';
import '../widgets/widgets.dart';
import '../data/mock_data.dart';
import 's4_home.dart';
import 's6_calendar.dart';
import 's7_bookings.dart';
import 's8_reports.dart';
import 's9_profile.dart';

class MainScreen extends StatefulWidget {
  final int initialTab;
  final bool isDarkMode;
  final VoidCallback onDarkModeToggle;

  const MainScreen({
    super.key,
    this.initialTab = 0,
    required this.isDarkMode,
    required this.onDarkModeToggle,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _tab;

  @override
  void initState() {
    super.initState();
    _tab = widget.initialTab;
  }

  int get _notifCount => AppData.notifications.where((n) => !n.read).length;

  List<Widget> get _pages {
    final isAdmin = AppData.user.isAdmin;
    return [
      HomeScreen(
        onNotifTap: () => Navigator.of(context).pushNamed('/notifications'),
        onTabChange: (i) => setState(() => _tab = i),
        notifCount: _notifCount,
      ),
      const BookingsScreen(),
      const CalendarScreen(),
      if (isAdmin) const ReportsScreen(),
      ProfileScreen(
        isDarkMode: widget.isDarkMode,
        onDarkModeToggle: widget.onDarkModeToggle,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final pages = _pages;
    final safeTab = _tab.clamp(0, pages.length - 1);

    return Scaffold(
      body: IndexedStack(
        index: safeTab,
        children: pages,
      ),
      bottomNavigationBar: BottomNav(
        activeIndex: safeTab,
        isAdmin: AppData.user.isAdmin,
        onTap: (i) => setState(() => _tab = i),
      ),
    );
  }
}
