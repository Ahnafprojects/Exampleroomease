import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../theme.dart';
import 'status_pill.dart';

Map<RoomType, Map<String, dynamic>> roomTypeCfg = {
  RoomType.boardroom:   {'bg': const Color(0xFFEFF6FF), 'icon': Icons.business,          'color': AppColors.blue},
  RoomType.meetingRoom: {'bg': const Color(0xFFF0FDF4), 'icon': Icons.groups,             'color': AppColors.green},
  RoomType.huddleSpace: {'bg': const Color(0xFFFFF7ED), 'icon': Icons.chat_bubble_outline, 'color': AppColors.amber},
  RoomType.training:    {'bg': const Color(0xFFFDF4FF), 'icon': Icons.bar_chart,           'color': AppColors.purple},
};

class RoomIconBlock extends StatelessWidget {
  final RoomType type;
  final double size;

  const RoomIconBlock({super.key, required this.type, this.size = 56});

  @override
  Widget build(BuildContext context) {
    final cfg = roomTypeCfg[type]!;
    final iconSize = size <= 32 ? 16.0 : size == 40 ? 20.0 : size == 48 ? 24.0 : 28.0;
    final radius = size <= 32 ? 8.0 : 12.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: cfg['bg'] as Color,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Icon(cfg['icon'] as IconData, size: iconSize, color: cfg['color'] as Color),
    );
  }
}

class RoomCard extends StatefulWidget {
  final Room room;
  final VoidCallback? onTap;
  final bool compact;

  const RoomCard({super.key, required this.room, this.onTap, this.compact = false});

  @override
  State<RoomCard> createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> {
  bool _pressed = false;

  static final facilityIcons = {
    'TV': Icons.tv,
    'Projector': Icons.videocam_outlined,
    'Speaker': Icons.volume_up_outlined,
    'WiFi': Icons.wifi,
    'Whiteboard': Icons.edit_outlined,
    'Video Call': Icons.video_call_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final isMaint = widget.room.status == RoomStatus.maintenance;
    return GestureDetector(
      onTapDown: (_) { if (!isMaint) setState(() => _pressed = true); },
      onTapUp: (_) { setState(() => _pressed = false); if (!isMaint) widget.onTap?.call(); },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.985 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 2))],
          ),
          child: Row(
            children: [
              RoomIconBlock(type: widget.room.type, size: widget.compact ? 48 : 56),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.room.name,
                      style: GoogleFonts.sora(fontSize: 15, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${widget.room.capacity} orang · ${widget.room.floor}',
                      style: GoogleFonts.sora(fontSize: 13, color: AppColors.t2),
                    ),
                    if (!widget.compact) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          ...widget.room.facilities.take(3).map((f) => Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Icon(facilityIcons[f] ?? Icons.settings_outlined, size: 14, color: AppColors.t3),
                          )),
                          if (isMaint)
                            Text('Sedang maintenance', style: GoogleFonts.sora(fontSize: 11, color: AppColors.maintenanceText)),
                        ],
                      ),
                    ],
                    if (widget.compact && isMaint)
                      Text('Tidak tersedia', style: GoogleFonts.sora(fontSize: 11, color: AppColors.red)),
                  ],
                ),
              ),
              StatusPill(roomStatus: widget.room.status),
            ],
          ),
        ),
      ),
    );
  }
}
