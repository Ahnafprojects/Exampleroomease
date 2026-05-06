import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

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
          color: (color ?? AppColors.navy).withValues(alpha: loading ? 0.8 : 1),
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

class AuthCTAButton extends StatelessWidget {
  final String label;
  final bool loading;
  final VoidCallback? onTap;

  const AuthCTAButton({
    super.key,
    required this.label,
    this.loading = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        height: 54,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.navy.withValues(alpha: loading ? 0.85 : 1),
          borderRadius: BorderRadius.circular(14),
          boxShadow: loading
              ? null
              : const [
                  BoxShadow(
                    color: Color(0x381C2B4A),
                    blurRadius: 20, offset: Offset(0, 8),
                  ),
                ],
        ),
        child: Center(
          child: loading
              ? const SizedBox(
                  width: 20, height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.sora(
                        fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.arrow_forward, size: 16, color: Colors.white),
                  ],
                ),
        ),
      ),
    );
  }
}
