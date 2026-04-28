import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../widgets/widgets.dart';
import '../models/models.dart';
import '../data/mock_data.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  String _activeChip = 'Semua';

  static const _chips = ['Semua', 'Kapasitas Kecil', 'Kapasitas Besar', 'Ada Projector', 'Tersedia Sekarang'];

  List<Room> get _filtered {
    final rooms = AppData.rooms;
    return rooms.where((r) {
      if (_query.length >= 2) {
        final q = _query.toLowerCase();
        if (!r.name.toLowerCase().contains(q) && !r.floor.toLowerCase().contains(q)) return false;
      }
      switch (_activeChip) {
        case 'Kapasitas Kecil': if (r.capacity > 4) return false;
        case 'Kapasitas Besar': if (r.capacity <= 10) return false;
        case 'Ada Projector': if (!r.facilities.contains('Projector')) return false;
        case 'Tersedia Sekarang': if (r.status != RoomStatus.available) return false;
      }
      return true;
    }).toList();
  }

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: RoomEaseAppBar(title: 'Cari Ruangan', showBack: false),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Icon(Icons.search, size: 20, color: AppColors.t3),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchCtrl,
                      onChanged: (v) => setState(() => _query = v),
                      style: GoogleFonts.sora(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Cari nama ruangan atau lantai...',
                        hintStyle: GoogleFonts.sora(fontSize: 14, color: AppColors.t3),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ),
                  if (_query.isNotEmpty)
                    GestureDetector(
                      onTap: () { _searchCtrl.clear(); setState(() => _query = ''); },
                      child: const Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: Icon(Icons.close, size: 16, color: AppColors.t3),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Filter chips
          SizedBox(
            height: 52,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              itemCount: _chips.length,
              itemBuilder: (_, i) {
                final chip = _chips[i];
                final isActive = chip == _activeChip;
                return GestureDetector(
                  onTap: () => setState(() => _activeChip = chip),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.navy : Colors.white,
                      borderRadius: BorderRadius.circular(99),
                      border: Border.all(color: isActive ? AppColors.navy : AppColors.border),
                    ),
                    child: Text(
                      chip,
                      style: GoogleFonts.sora(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isActive ? Colors.white : AppColors.t2,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Results
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off, size: 64, color: Color(0xFFD1D5DB)),
                        const SizedBox(height: 12),
                        Text('Tidak ditemukan', style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.t1)),
                        Text('Coba kata kunci lain', style: GoogleFonts.sora(fontSize: 13, color: AppColors.t2)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) => RoomCard(
                      room: filtered[i],
                      onTap: filtered[i].status != RoomStatus.maintenance
                          ? () => Navigator.of(context).pushNamed('/room-detail', arguments: filtered[i])
                          : null,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
