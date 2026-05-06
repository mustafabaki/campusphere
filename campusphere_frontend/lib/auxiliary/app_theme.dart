import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// CampuSphere "Academic Clarity" Design System
/// Derived from the reference DESIGN.md color palette and typography.
class AppColors {
  // ── Primary ──────────────────────────────────────────────
  static const Color primary = Color(0xFF001E40);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF003366);
  static const Color onPrimaryContainer = Color(0xFF799DD6);
  static const Color inversePrimary = Color(0xFFA7C8FF);

  // ── Secondary ────────────────────────────────────────────
  static const Color secondary = Color(0xFF705D00);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFFCD400);
  static const Color onSecondaryContainer = Color(0xFF6E5C00);

  // ── Tertiary ─────────────────────────────────────────────
  static const Color tertiary = Color(0xFF00222B);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF003946);
  static const Color onTertiaryContainer = Color(0xFF00AACC);

  // ── Error ────────────────────────────────────────────────
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  // ── Surface variants ────────────────────────────────────
  static const Color surface = Color(0xFFF8F9FF);
  static const Color surfaceDim = Color(0xFFCBDBF5);
  static const Color surfaceBright = Color(0xFFF8F9FF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFEFF4FF);
  static const Color surfaceContainer = Color(0xFFE5EEFF);
  static const Color surfaceContainerHigh = Color(0xFFDCE9FF);
  static const Color surfaceContainerHighest = Color(0xFFD3E4FE);

  // ── On-Surface ──────────────────────────────────────────
  static const Color onSurface = Color(0xFF0B1C30);
  static const Color onSurfaceVariant = Color(0xFF43474F);
  static const Color inverseSurface = Color(0xFF213145);
  static const Color inverseOnSurface = Color(0xFFEAF1FF);

  // ── Outline ─────────────────────────────────────────────
  static const Color outline = Color(0xFF737780);
  static const Color outlineVariant = Color(0xFFC3C6D1);

  // ── Fixed colors ────────────────────────────────────────
  static const Color primaryFixed = Color(0xFFD5E3FF);
  static const Color primaryFixedDim = Color(0xFFA7C8FF);
  static const Color surfaceTint = Color(0xFF3A5F94);

  // ── Convenience aliases from DESIGN.md ──────────────────
  static const Color universityBlue = Color(0xFF003366);
  static const Color academicGold = Color(0xFFFFD700);
  static const Color supportiveBlue = Color(0xFF00B4D8);
  static const Color deepCharcoal = Color(0xFF0F172A);
  static const Color background = Color(0xFFF8FAFC);
}

class AppTheme {
  static ThemeData get lightTheme {
    final textTheme = TextTheme(
      // Headline XL – Lexend 40px Bold
      displayLarge: GoogleFonts.lexend(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: AppColors.onSurface,
      ),
      // Headline LG – Lexend 32px SemiBold
      displayMedium: GoogleFonts.lexend(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: AppColors.onSurface,
      ),
      // Headline MD – Lexend 24px SemiBold
      displaySmall: GoogleFonts.lexend(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: AppColors.onSurface,
      ),
      // Body LG – Inter 18px Regular
      bodyLarge: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: AppColors.onSurfaceVariant,
      ),
      // Body MD – Inter 16px Regular
      bodyMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.onSurface,
      ),
      // Body SM – Inter 14px Regular
      bodySmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.onSurfaceVariant,
      ),
      // Label MD – Inter 14px SemiBold
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.0,
        letterSpacing: 0.28,
        color: AppColors.onSurface,
      ),
      // Label SM – Inter 12px Medium
      labelSmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.0,
        letterSpacing: 0.48,
        color: AppColors.onSurfaceVariant,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryContainer,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onTertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        onTertiaryContainer: AppColors.onTertiaryContainer,
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        inverseSurface: AppColors.inverseSurface,
        onInverseSurface: AppColors.inverseOnSurface,
        inversePrimary: AppColors.inversePrimary,
        surfaceTint: AppColors.surfaceTint,
      ),
      scaffoldBackgroundColor: AppColors.surface,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white.withValues(alpha: 0.95),
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        shadowColor: AppColors.primaryContainer.withValues(alpha: 0.05),
        titleTextStyle: GoogleFonts.lexend(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: AppColors.universityBlue,
          letterSpacing: -0.5,
        ),
        iconTheme: const IconThemeData(color: AppColors.universityBlue),
      ),
    );
  }
}
