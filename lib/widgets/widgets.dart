import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../theme.dart';

// ── Status Pill ──────────────────────────────────────────────────────
class StatusPill extends StatelessWidget {
  final BookingStatus? bookingStatus;
  final RoomStatus? roomStatus;

  const StatusPill({super.key, this.bookingStatus, this.roomStatus});

  @override
  Widget build(BuildContext context) {
    Color bg, text, dot;
    String label;

    if (bookingStatus != null) {
      switch (bookingStatus!) {
        case BookingStatus.booked:
          bg = AppColors.bookedBg; text = AppColors.bookedText; dot = AppColors.red; label = 'Upcoming';
        case BookingStatus.checkedin:
          bg = AppColors.checkedinBg; text = AppColors.checkedinText; dot = AppColors.orange; label = 'Check-in';
        case BookingStatus.done:
          bg = AppColors.doneBg; text = AppColors.doneText; dot = AppColors.t3; label = 'Selesai';
        case BookingStatus.cancelled:
          bg = AppColors.doneBg; text = AppColors.doneText; dot = AppColors.red; label = 'Dibatalkan';
        case BookingStatus.noshow:
          bg = AppColors.bookedBg; text = AppColors.bookedText; dot = AppColors.red; label = 'No-show';
      }
    } else {
      switch (roomStatus!) {
        case RoomStatus.available:
          bg = AppColors.availableBg; text = AppColors.availableText; dot = AppColors.green; label = 'Tersedia';
        case RoomStatus.booked:
          bg = AppColors.bookedBg; text = AppColors.bookedText; dot = AppColors.red; label = 'Penuh';
        case RoomStatus.checkedin:
          bg = AppColors.checkedinBg; text = AppColors.checkedinText; dot = AppColors.orange; label = 'Check-in';
        case RoomStatus.maintenance:
          bg = AppColors.maintenanceBg; text = AppColors.maintenanceText; dot = const Color(0xFF94A3B8); label = 'Maintenance';
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(99)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 6, height: 6, decoration: BoxDecoration(color: dot, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(label, style: GoogleFonts.sora(fontSize: 11, fontWeight: FontWeight.w600, color: text)),
        ],
      ),
    );
  }
}

// ── Room Type Config ──────────────────────────────────────────────────
Map<RoomType, Map<String, dynamic>> roomTypeCfg = {
  RoomType.boardroom:   {'bg': const Color(0xFFEFF6FF), 'icon': Icons.business,         'color': AppColors.blue},
  RoomType.meetingRoom: {'bg': const Color(0xFFF0FDF4), 'icon': Icons.groups,            'color': AppColors.green},
  RoomType.huddleSpace: {'bg': const Color(0xFFFFF7ED), 'icon': Icons.chat_bubble_outline,'color': AppColors.amber},
  RoomType.training:    {'bg': const Color(0xFFFDF4FF), 'icon': Icons.bar_chart,          'color': AppColors.purple},
};

// ── Room Icon Block ───────────────────────────────────────────────────
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

// ── Room Card ─────────────────────────────────────────────────────────
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
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 2))],
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

// ── Booking Card Horizontal ───────────────────────────────────────────
class BookingCardH extends StatelessWidget {
  final Booking booking;
  final VoidCallback? onCheckin;

  const BookingCardH({super.key, required this.booking, this.onCheckin});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              RoomIconBlock(type: booking.roomType, size: 32),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  booking.roomName,
                  style: GoogleFonts.sora(fontSize: 15, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(children: [
            const Icon(Icons.access_time, size: 12, color: AppColors.t2),
            const SizedBox(width: 4),
            Text('${booking.time}–${booking.endTime}', style: GoogleFonts.sora(fontSize: 12, color: AppColors.t2)),
          ]),
          const SizedBox(height: 2),
          Row(children: [
            const Icon(Icons.location_on_outlined, size: 12, color: AppColors.t2),
            const SizedBox(width: 4),
            Text(booking.floor, style: GoogleFonts.sora(fontSize: 12, color: AppColors.t2)),
          ]),
          if (booking.status == BookingStatus.booked) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: onCheckin,
              child: Container(
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Center(
                  child: Text('Check-in Sekarang', style: GoogleFonts.sora(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Section Header ────────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const SectionHeader({super.key, required this.title, this.action, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.w600)),
          if (action != null)
            GestureDetector(
              onTap: onAction,
              child: Text(action!, style: GoogleFonts.sora(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.amber)),
            ),
        ],
      ),
    );
  }
}

// ── Shimmer / Skeleton ────────────────────────────────────────────────
class ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final double radius;

  const ShimmerBox({super.key, required this.width, required this.height, this.radius = 6});

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat();
    _anim = Tween<double>(begin: -2, end: 2).animate(CurvedAnimation(parent: _ctrl, curve: Curves.linear));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            gradient: LinearGradient(
              begin: Alignment(_anim.value, 0),
              end: Alignment(_anim.value + 1, 0),
              colors: const [Color(0xFFF3F4F6), Color(0xFFE5E7EB), Color(0xFFF3F4F6)],
            ),
          ),
        );
      },
    );
  }
}

class SkeletonRoomCard extends StatelessWidget {
  const SkeletonRoomCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      height: 88,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          const ShimmerBox(width: 56, height: 56, radius: 12),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              ShimmerBox(width: 120, height: 12),
              SizedBox(height: 8),
              ShimmerBox(width: 80, height: 10),
              SizedBox(height: 8),
              ShimmerBox(width: 100, height: 10),
            ],
          ),
        ],
      ),
    );
  }
}

class SkeletonStatCard extends StatelessWidget {
  const SkeletonStatCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 16, offset: const Offset(0, 4))],
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShimmerBox(width: 32, height: 24),
            SizedBox(height: 8),
            ShimmerBox(width: 60, height: 10),
          ],
        ),
      ),
    );
  }
}

// ── Top App Bar ───────────────────────────────────────────────────────
class RoomEaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onLeft;
  final IconData? rightIcon;
  final VoidCallback? onRight;
  final bool showBack;

  const RoomEaseAppBar({
    super.key,
    required this.title,
    this.onLeft,
    this.rightIcon,
    this.onRight,
    this.showBack = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: GoogleFonts.sora(fontSize: 17, fontWeight: FontWeight.w600)),
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onLeft ?? () => Navigator.of(context).pop(),
            )
          : null,
      actions: [
        if (rightIcon != null)
          IconButton(icon: Icon(rightIcon), onPressed: onRight),
      ],
    );
  }
}

// ── Facility Chip ─────────────────────────────────────────────────────
class FacilityChip extends StatelessWidget {
  final String label;
  const FacilityChip({super.key, required this.label});

  static const _icons = {
    'TV': Icons.tv,
    'Projector': Icons.videocam_outlined,
    'Speaker': Icons.volume_up_outlined,
    'WiFi': Icons.wifi,
    'Whiteboard': Icons.edit_outlined,
    'Video Call': Icons.video_call_outlined,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_icons[label] != null) ...[
            Icon(_icons[label]!, size: 14, color: AppColors.t2),
            const SizedBox(width: 4),
          ],
          Text(label, style: GoogleFonts.sora(fontSize: 13, color: AppColors.t2)),
        ],
      ),
    );
  }
}

// ── Input Field ───────────────────────────────────────────────────────
class AppInputField extends StatefulWidget {
  final String label;
  final String placeholder;
  final String? value;
  final ValueChanged<String>? onChange;
  final TextInputType? keyboardType;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final VoidCallback? onRightIconTap;
  final bool obscureText;
  final String? errorText;
  final bool enabled;
  final TextEditingController? controller;

  const AppInputField({
    super.key,
    required this.label,
    required this.placeholder,
    this.value,
    this.onChange,
    this.keyboardType,
    this.leftIcon,
    this.rightIcon,
    this.onRightIconTap,
    this.obscureText = false,
    this.errorText,
    this.enabled = true,
    this.controller,
  });

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> {
  bool _focused = false;
  late FocusNode _focus;

  @override
  void initState() {
    super.initState();
    _focus = FocusNode()..addListener(() => setState(() => _focused = _focus.hasFocus));
  }

  @override
  void dispose() { _focus.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    final borderColor = hasError ? AppColors.red : _focused ? AppColors.navy : AppColors.border;
    final borderWidth = (hasError || _focused) ? 2.0 : 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.sora(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: _focused ? AppColors.navy : AppColors.t1,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: widget.enabled ? Colors.white : const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: borderWidth),
            boxShadow: _focused && !hasError
                ? [BoxShadow(color: AppColors.navy.withOpacity(0.08), blurRadius: 0, spreadRadius: 3)]
                : null,
          ),
          child: Row(
            children: [
              if (widget.leftIcon != null)
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Icon(widget.leftIcon!, size: 16,
                    color: hasError ? AppColors.red : _focused ? AppColors.navy : AppColors.t3),
                ),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focus,
                  enabled: widget.enabled,
                  obscureText: widget.obscureText,
                  keyboardType: widget.keyboardType,
                  onChanged: widget.onChange,
                  style: GoogleFonts.sora(fontSize: 14, color: AppColors.t1),
                  decoration: InputDecoration(
                    hintText: widget.placeholder,
                    hintStyle: GoogleFonts.sora(fontSize: 14, color: AppColors.t3),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: widget.leftIcon != null ? 12 : 16, right: 16),
                  ),
                ),
              ),
              if (widget.rightIcon != null)
                GestureDetector(
                  onTap: widget.onRightIconTap,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(widget.rightIcon!, size: 16, color: AppColors.t3),
                  ),
                ),
            ],
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(widget.errorText!, style: GoogleFonts.sora(fontSize: 11, color: AppColors.red)),
          ),
      ],
    );
  }
}

// ── Bottom Navigation ─────────────────────────────────────────────────
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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, -4))],
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

// ── Primary Button ────────────────────────────────────────────────────
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool loading;
  final Color? color;
  final Color? textColor;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onTap,
    this.loading = false,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        height: 52,
        width: double.infinity,
        decoration: BoxDecoration(
          color: (color ?? AppColors.navy).withOpacity(loading ? 0.8 : 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: loading
              ? const SizedBox(
                  width: 20, height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Text(
                  label,
                  style: GoogleFonts.sora(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor ?? Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
