import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../widgets/widgets.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _period = 'Bulan Ini';
  bool _loading = false;

  static const _periods = ['Hari Ini', 'Minggu Ini', 'Bulan Ini'];

  static final _kpiCards = [
    _KpiCard(iconBg: const Color(0xFFEFF6FF), icon: Icons.calendar_today, iconColor: AppColors.blue, value: '24', label: 'Total Booking'),
    _KpiCard(iconBg: const Color(0xFFDCFCE7), icon: Icons.bar_chart, iconColor: AppColors.green, value: '73%', label: 'Utilisasi'),
    _KpiCard(iconBg: const Color(0xFFFEE2E2), icon: Icons.remove_circle_outline, iconColor: AppColors.red, value: '12%', label: 'Ghost Booking'),
    _KpiCard(iconBg: const Color(0xFFFEF3C7), icon: Icons.warning_amber_outlined, iconColor: AppColors.orange, value: '3', label: 'No-show'),
  ];

  static final _utilBars = [
    _UtilBar('Boardroom A',     0.82, AppColors.blue),
    _UtilBar('Meeting Room B',  0.65, AppColors.green),
    _UtilBar('Huddle Space C',  0.91, AppColors.amber),
    _UtilBar('Training Room D', 0.34, AppColors.purple),
  ];

  static const _days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum'];
  static const _hours = ['08', '09', '10', '11', '12', '13', '14', '15', '16'];
  static const _heatData = [
    [20, 45, 78, 82, 60, 55, 70, 40, 20],
    [15, 60, 85, 90, 72, 65, 88, 55, 25],
    [30, 50, 70, 75, 55, 60, 65, 45, 30],
    [10, 40, 65, 80, 68, 50, 72, 38, 15],
    [25, 55, 88, 92, 75, 70, 80, 50, 22],
  ];

  Color _heatColor(int pct) {
    if (pct < 20) return const Color(0xFFF3F4F6);
    if (pct < 40) return const Color(0xFFDBEAFE);
    if (pct < 60) return const Color(0xFF93C5FD);
    if (pct < 80) return AppColors.blue;
    return const Color(0xFF1D4ED8);
  }

  void _changePeriod(String p) {
    setState(() { _period = p; _loading = true; });
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: RoomEaseAppBar(
        title: 'Laporan Utilisasi',
        showBack: false,
        rightIcon: Icons.download_outlined,
        onRight: () => _showExportSheet(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period selector
            Container(
              height: 44,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: _periods.map((p) {
                  final isActive = p == _period;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => _changePeriod(p),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        height: 36,
                        decoration: BoxDecoration(
                          color: isActive ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: isActive ? [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8)] : null,
                        ),
                        child: Center(
                          child: Text(p, style: GoogleFonts.sora(fontSize: 13, fontWeight: FontWeight.w600, color: isActive ? AppColors.navy : AppColors.t2)),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // KPI Grid
            _loading
                ? GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.8,
                    children: List.generate(4, (_) => Container(
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                      child: const Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.navy)),
                    )),
                  )
                : GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.8,
                    children: _kpiCards.map((card) => _KpiCardWidget(card: card)).toList(),
                  ),
            const SizedBox(height: 24),

            // Utilization bars
            Text('Utilisasi per Ruangan', style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.t1)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)],
              ),
              child: Column(
                children: _utilBars.map((b) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(b.name, style: GoogleFonts.sora(fontSize: 13, color: AppColors.t1)),
                          Text('${(b.pct * 100).toInt()}%', style: GoogleFonts.sora(fontSize: 13, fontWeight: FontWeight.w600, color: b.color)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: LinearProgressIndicator(
                          value: b.pct,
                          minHeight: 8,
                          backgroundColor: const Color(0xFFF3F4F6),
                          valueColor: AlwaysStoppedAnimation<Color>(b.color),
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Heatmap
            Text('Heatmap Peak Hours', style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.t1)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)],
              ),
              child: Column(
                children: [
                  // Hours header
                  Row(
                    children: [
                      const SizedBox(width: 32),
                      ..._hours.map((h) => Expanded(
                        child: Center(child: Text(h, style: GoogleFonts.sora(fontSize: 9, color: AppColors.t3))),
                      )),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ...List.generate(_days.length, (di) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        SizedBox(width: 32, child: Center(child: Text(_days[di], style: GoogleFonts.sora(fontSize: 10, color: AppColors.t2)))),
                        ..._hours.asMap().entries.map((e) => Expanded(
                          child: Container(
                            height: 28,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              color: _heatColor(_heatData[di][e.key]),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        )),
                      ],
                    ),
                  )),
                  // Legend
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Rendah', style: GoogleFonts.sora(fontSize: 10, color: AppColors.t3)),
                        const SizedBox(width: 8),
                        ...const [Color(0xFFF3F4F6), Color(0xFFDBEAFE), Color(0xFF93C5FD), AppColors.blue, Color(0xFF1D4ED8)].map((c) => Container(
                          width: 20, height: 12, margin: const EdgeInsets.only(right: 2),
                          decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(2)),
                        )),
                        const SizedBox(width: 8),
                        Text('Tinggi', style: GoogleFonts.sora(fontSize: 10, color: AppColors.t3)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExportSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(99)))),
            const SizedBox(height: 20),
            Text('Ekspor Laporan', style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text('Pilih format file untuk mengunduh laporan', style: GoogleFonts.sora(fontSize: 13, color: AppColors.t2)),
            const SizedBox(height: 20),
            ...['PDF', 'Excel (XLSX)', 'CSV'].map((fmt) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.green,
                      content: Text('Mengunduh laporan $fmt...', style: GoogleFonts.sora(color: Colors.white)),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Icon(Icons.description_outlined, size: 20, color: AppColors.navy),
                        const SizedBox(width: 12),
                        Text(fmt, style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.t1)),
                        const Spacer(),
                        const Icon(Icons.download_outlined, size: 16, color: AppColors.t3),
                      ],
                    ),
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class _KpiCard {
  final Color iconBg;
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  const _KpiCard({required this.iconBg, required this.icon, required this.iconColor, required this.value, required this.label});
}

class _KpiCardWidget extends StatelessWidget {
  final _KpiCard card;
  const _KpiCardWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: card.iconBg, shape: BoxShape.circle),
            child: Icon(card.icon, size: 18, color: card.iconColor),
          ),
          const SizedBox(height: 8),
          Text(card.value, style: GoogleFonts.sora(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.t1)),
          Text(card.label, style: GoogleFonts.sora(fontSize: 11, color: AppColors.t2)),
        ],
      ),
    );
  }
}

class _UtilBar {
  final String name;
  final double pct;
  final Color color;
  const _UtilBar(this.name, this.pct, this.color);
}
