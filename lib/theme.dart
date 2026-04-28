import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const navy = Color(0xFF1C2B4A);
  static const amber = Color(0xFFF59E0B);
  static const bg = Color(0xFFF5F4F0);
  static const surface = Color(0xFFFFFFFF);
  static const green = Color(0xFF16A34A);
  static const red = Color(0xFFDC2626);
  static const orange = Color(0xFFD97706);
  static const purple = Color(0xFFA855F7);
  static const blue = Color(0xFF3B82F6);
  static const t1 = Color(0xFF111827);
  static const t2 = Color(0xFF6B7280);
  static const t3 = Color(0xFF9CA3AF);
  static const border = Color(0xFFE5E7EB);

  // Dark mode
  static const darkBg = Color(0xFF0F172A);
  static const darkSurface = Color(0xFF1E293B);
  static const darkT1 = Color(0xFFF1F5F9);
  static const darkT2 = Color(0xFF94A3B8);
  static const darkT3 = Color(0xFF64748B);
  static const darkBorder = Color(0xFF334155);
  static const darkNavy = Color(0xFF3B82F6);

  // Status colors
  static const availableBg = Color(0xFFDCFCE7);
  static const availableText = Color(0xFF16A34A);
  static const bookedBg = Color(0xFFFEE2E2);
  static const bookedText = Color(0xFFDC2626);
  static const checkedinBg = Color(0xFFFEF3C7);
  static const checkedinText = Color(0xFFD97706);
  static const doneBg = Color(0xFFF3F4F6);
  static const doneText = Color(0xFF6B7280);
  static const maintenanceBg = Color(0xFFF1F5F9);
  static const maintenanceText = Color(0xFF64748B);
}

TextTheme _buildTextTheme() {
  return GoogleFonts.soraTextTheme();
}

ThemeData buildLightTheme() {
  final base = ThemeData.light(useMaterial3: true);
  return base.copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.navy,
      primary: AppColors.navy,
      secondary: AppColors.amber,
      surface: AppColors.surface,
      error: AppColors.red,
    ),
    scaffoldBackgroundColor: AppColors.bg,
    textTheme: _buildTextTheme().apply(
      bodyColor: AppColors.t1,
      displayColor: AppColors.t1,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.surface,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.sora(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: AppColors.t1,
      ),
      iconTheme: const IconThemeData(color: AppColors.t1),
    ),
  );
}

ThemeData buildDarkTheme() {
  final base = ThemeData.dark(useMaterial3: true);
  return base.copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.darkNavy,
      brightness: Brightness.dark,
      primary: AppColors.darkNavy,
      secondary: AppColors.amber,
      surface: AppColors.darkSurface,
      error: AppColors.red,
    ),
    scaffoldBackgroundColor: AppColors.darkBg,
    textTheme: _buildTextTheme().apply(
      bodyColor: AppColors.darkT1,
      displayColor: AppColors.darkT1,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.sora(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: AppColors.darkT1,
      ),
      iconTheme: const IconThemeData(color: AppColors.darkT1),
    ),
  );
}
