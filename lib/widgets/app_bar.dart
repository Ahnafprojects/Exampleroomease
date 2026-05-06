import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
