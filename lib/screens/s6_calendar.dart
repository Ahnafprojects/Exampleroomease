import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../widgets/widgets.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int _viewYear = 2026;
  int _viewMonth = 2; // March (0-indexed)
  int _selectedDay = 10;

  static const _daysId = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];
  static const _monthsId = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];
  static const _hasBooking = [10, 12, 14, 17, 21];

  static const _timelineBookings = [
    _TimelineItem('Boardroom A',     'Sprint Planning', Color(0xFFDBEAFE), Color(0xFF1D4ED8), 0.18, 0.30),
    _TimelineItem('Meeting Room B',  '1-on-1',          Color(0xFFDCFCE7), Color(0xFF15803D), 0.50, 0.10),
    _TimelineItem('Huddle Space C',  'Quick Sync',      Color(0xFFFEF3C7), Color(0xFF92400E), 0.38, 0.10),
    _TimelineItem('Training Room D', 'Onboarding',      Color(0xFFF3E8FF), Color(0xFF7E22CE), 0.00, 0.67),
  ];

  List<Map<String, dynamic>> _buildCalendarDays() {
    final firstDay = DateTime(_viewYear, _viewMonth + 1, 1).weekday % 7; // Sun = 0
    final daysInMonth = DateTime(_viewYear, _viewMonth + 2, 0).day;
    final daysInPrev = DateTime(_viewYear, _viewMonth + 1, 0).day;
    final cells = <Map<String, dynamic>>[];
    for (int i = firstDay - 1; i >= 0; i--) {
      cells.add({'day': daysInPrev - i, 'thisMonth': false});
    }
    for (int i = 1; i <= daysInMonth; i++) {
      cells.add({'day': i, 'thisMonth': true});
    }
    final remaining = 42 - cells.length;
    for (int i = 1; i <= remaining; i++) {
      cells.add({'day': i, 'thisMonth': false});
    }
    return cells;
  }

  void _prevMonth() {
    setState(() {
      if (_viewMonth == 0) { _viewYear--; _viewMonth = 11; }
      else { _viewMonth--; }
    });
  }

  void _nextMonth() {
    setState(() {
      if (_viewMonth == 11) { _viewYear++; _viewMonth = 0; }
      else { _viewMonth++; }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cells = _buildCalendarDays();
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: RoomEaseAppBar(
        title: 'Kalender',
        showBack: false,
        rightIcon: Icons.add,
        onRight: () => Navigator.of(context).pushNamed('/booking-form'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          children: [
            // Month header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _prevMonth,
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)],
                      ),
                      child: const Icon(Icons.arrow_back, size: 16, color: AppColors.t1),
                    ),
                  ),
                  Text('${_monthsId[_viewMonth]} $_viewYear',
                    style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.t1)),
                  GestureDetector(
                    onTap: _nextMonth,
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)],
                      ),
                      child: const Icon(Icons.arrow_forward, size: 16, color: AppColors.t1),
                    ),
                  ),
                ],
              ),
            ),

            // Calendar card
            Container(
              margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)],
              ),
              child: Column(
                children: [
                  // Day headers
                  Row(
                    children: _daysId.map((d) => Expanded(
                      child: SizedBox(
                        height: 44,
                        child: Center(
                          child: Text(d, style: GoogleFonts.sora(fontSize: 11, color: AppColors.t3)),
                        ),
                      ),
                    )).toList(),
                  ),
                  // Calendar grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      childAspectRatio: 1,
                    ),
                    itemCount: cells.length,
                    itemBuilder: (_, i) {
                      final cell = cells[i];
                      final isToday = cell['thisMonth'] && cell['day'] == 10 && _viewMonth == 2 && _viewYear == 2026;
                      final isSelected = cell['thisMonth'] && cell['day'] == _selectedDay;
                      final hasDot = cell['thisMonth'] && _hasBooking.contains(cell['day']);
                      return GestureDetector(
                        onTap: () { if (cell['thisMonth']) setState(() => _selectedDay = cell['day']); },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 36, height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isToday ? AppColors.navy : isSelected ? AppColors.checkedinBg : Colors.transparent,
                              ),
                              child: Center(
                                child: Text(
                                  '${cell['day']}',
                                  style: GoogleFonts.sora(
                                    fontSize: 14,
                                    fontWeight: (isToday || isSelected) ? FontWeight.w600 : FontWeight.w400,
                                    color: isToday ? Colors.white : isSelected ? AppColors.orange : cell['thisMonth'] ? AppColors.t1 : const Color(0xFFD1D5DB),
                                  ),
                                ),
                              ),
                            ),
                            if (hasDot && !isSelected && !isToday)
                              Container(width: 6, height: 6, margin: const EdgeInsets.only(top: 2), decoration: const BoxDecoration(color: AppColors.amber, shape: BoxShape.circle)),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Timeline
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Timeline $_selectedDay ${_monthsId[_viewMonth]}',
                    style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.t1)),
                  const SizedBox(height: 12),
                  ..._timelineBookings.map((item) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(item.room, style: GoogleFonts.sora(fontSize: 12, color: AppColors.t2), overflow: TextOverflow.ellipsis),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Stack(
                            children: [
                              Container(height: 28, decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(6))),
                              FractionallySizedBox(
                                widthFactor: item.width,
                                child: FractionalTranslation(
                                  translation: Offset(item.left / item.width, 0),
                                  child: Container(
                                    height: 28,
                                    decoration: BoxDecoration(color: item.bg, borderRadius: BorderRadius.circular(6)),
                                    child: Center(
                                      child: Text(item.label, style: GoogleFonts.sora(fontSize: 11, fontWeight: FontWeight.w600, color: item.textColor), overflow: TextOverflow.ellipsis),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineItem {
  final String room;
  final String label;
  final Color bg;
  final Color textColor;
  final double left;
  final double width;
  const _TimelineItem(this.room, this.label, this.bg, this.textColor, this.left, this.width);
}
