import 'package:flutter/material.dart';

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
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          const ShimmerBox(width: 56, height: 56, radius: 12),
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 16, offset: const Offset(0, 4))],
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
