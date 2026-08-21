import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// The "Undyed" palette: unbleached cotton and ink, with no accent colour.
/// Everything coloured on screen is meant to be the cloth itself.
abstract final class AppColors {
  static const paper = Color(0xFFF8F5EF);
  static const card = Color(0xFFFFFDF9);
  static const ink = Color(0xFF2A2521);
  static const muted = Color(0xFF7A736C);
  static const line = Color(0xFFE5E0D8);
  static const swatch = Color(0xFFEFEAE1);
  static const ghost = Color(0xFFB4ADA4);
  static const onInk = Color(0xFFFBF8F2);
}

abstract final class AppTheme {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.ink,
      brightness: Brightness.light,
    ).copyWith(
      surface: AppColors.paper,
      primary: AppColors.ink,
      onPrimary: AppColors.onInk,
      outline: AppColors.line,
    );

    // Instrument Serif for display, Karla for everything else. Loaded at runtime
    // by google_fonts for now — worth bundling before release so a first launch
    // on a poor connection is not waiting on a font.
    final body = GoogleFonts.karlaTextTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.paper,
      textTheme: body.copyWith(
        displayLarge: GoogleFonts.instrumentSerif(
          fontSize: 46, height: 1.05, letterSpacing: 6, color: AppColors.ink),
        headlineMedium: GoogleFonts.instrumentSerif(
          fontSize: 30, height: 1.15, color: AppColors.ink),
        headlineSmall: GoogleFonts.instrumentSerif(
          fontSize: 24, height: 1.2, letterSpacing: 3, color: AppColors.ink),
        bodyLarge: GoogleFonts.karla(fontSize: 15, height: 1.5, color: AppColors.ink),
        bodyMedium: GoogleFonts.karla(fontSize: 14, height: 1.5, color: AppColors.muted),
        bodySmall: GoogleFonts.karla(fontSize: 12.5, height: 1.5, color: AppColors.ghost),
        labelLarge: GoogleFonts.karla(
          fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.onInk),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.paper,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.card,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: _border(AppColors.line),
        enabledBorder: _border(AppColors.line),
        focusedBorder: _border(AppColors.ink, width: 1.5),
        errorBorder: _border(const Color(0xFFA5503C)),
        focusedErrorBorder: _border(const Color(0xFFA5503C), width: 1.5),
        hintStyle: GoogleFonts.karla(fontSize: 15, color: AppColors.ghost),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.ink,
          foregroundColor: AppColors.onInk,
          // 52 keeps it clear of the 44pt minimum hit target on every device.
          minimumSize: const Size.fromHeight(52),
          shape: const StadiumBorder(),
          textStyle: GoogleFonts.karla(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.muted,
          minimumSize: const Size(0, 44),
          textStyle: GoogleFonts.karla(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  static OutlineInputBorder _border(Color colour, {double width = 1}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colour, width: width),
      );
}
