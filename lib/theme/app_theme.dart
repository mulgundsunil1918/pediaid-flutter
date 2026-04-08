import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ── Legacy palette constants (kept for backward compatibility) ────────────────
const Color primaryNavy   = Color(0xFF1565C0);
const Color primaryMid    = Color(0xFF1E88E5);
const Color accentTeal    = Color(0xFF00ACC1);
const Color accentWarm    = Color(0xFFFFE3B3);
const Color bgColor       = Color(0xFFF2F6FD);
const Color surfaceWhite  = Color(0xFFFFFFFF);
const Color textDark      = Color(0xFF0D1929);
const Color textMedium    = Color(0xFF375475);
const Color textLight     = Color(0xFF7A9ABB);
const Color errorRed      = Color(0xFFD32F2F);
const Color successGreen  = Color(0xFF2E7D32);
const Color warningAmber  = Color(0xFFF57C00);

class AppTheme {
  // ── LIGHT PALETTE ──────────────────────────────────────────────────────────
  static const Color lBg        = Color(0xFFF2F6FD);
  static const Color lSurface   = Color(0xFFFFFFFF);
  static const Color lCard      = Color(0xFFFFFFFF);
  static const Color lElevated  = Color(0xFFE8F0FB);
  static const Color lBorder    = Color(0xFFCBD8EB);
  static const Color lPrimary   = Color(0xFF1565C0);
  static const Color lPrimMid   = Color(0xFF1E88E5);
  static const Color lPrimCont  = Color(0xFFD6E8FF);
  static const Color lTextHigh  = Color(0xFF0D1929);
  static const Color lTextMed   = Color(0xFF375475);
  static const Color lTextLow   = Color(0xFF7A9ABB);
  static const Color lInputFg   = Color(0xFFF0F5FC);

  // ── DARK PALETTE (M3 blue-tinted dark — NOT pitch black) ───────────────────
  static const Color dBg        = Color(0xFF0F1117);  // deep blue-black
  static const Color dSurface   = Color(0xFF161C28);  // dark blue surface
  static const Color dCard      = Color(0xFF1C2336);  // card surface
  static const Color dElevated  = Color(0xFF232D42);  // elevated elements
  static const Color dBorder    = Color(0xFF2D3A52);  // subtle borders
  static const Color dPrimary   = Color(0xFF90C0FF);  // bright blue on dark
  static const Color dPrimMid   = Color(0xFF5B9BD5);
  static const Color dPrimCont  = Color(0xFF003A75);  // primary container
  static const Color dTextHigh  = Color(0xFFE2E8F5);  // near-white blue
  static const Color dTextMed   = Color(0xFFA0B0CC);  // medium blue-gray
  static const Color dTextLow   = Color(0xFF526077);  // dim blue-gray
  static const Color dInputFg   = Color(0xFF1C2336);

  // ── LIGHT THEME ────────────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    final base = _baseText(Brightness.light);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lBg,
      primaryColor: lPrimary,
      colorScheme: const ColorScheme.light(
        primary:            lPrimary,
        onPrimary:          Colors.white,
        primaryContainer:   lPrimCont,
        onPrimaryContainer: lTextHigh,
        secondary:          lPrimMid,
        onSecondary:        Colors.white,
        surface:            lSurface,
        onSurface:          lTextHigh,
        onSurfaceVariant:   lTextMed,
        outline:            lBorder,
        outlineVariant:     Color(0xFFDDE5F0),
        error:              Color(0xFFB00020),
        onError:            Colors.white,
        surfaceContainerHighest: lElevated,
      ),
      cardColor: lCard,
      textTheme: base,
      appBarTheme: AppBarTheme(
        backgroundColor: lPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme: const IconThemeData(color: Colors.white),
      ),
      cardTheme: CardThemeData(
        color: lCard,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFCBD8EB), width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lInputFg,
        labelStyle: const TextStyle(color: lTextMed, fontSize: 14),
        hintStyle: const TextStyle(color: lTextLow, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lPrimary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lPrimary,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: lPrimary,
          side: const BorderSide(color: lPrimary, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: lPrimary),
      ),
      iconTheme: const IconThemeData(color: lTextMed),
      dividerColor: lBorder,
      dividerTheme: const DividerThemeData(color: lBorder, thickness: 1),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected) ? lPrimary : Colors.grey.shade400),
        trackColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected) ? lPrimCont : Colors.grey.shade300),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: lElevated,
        labelStyle: TextStyle(color: lTextHigh, fontSize: 13,
            fontFamily: GoogleFonts.plusJakartaSans().fontFamily),
        selectedColor: lPrimary,
        secondaryLabelStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: const BorderSide(color: lBorder),
      ),
    );
  }

  // ── DARK THEME ─────────────────────────────────────────────────────────────
  static ThemeData get darkTheme {
    final base = _baseText(Brightness.dark);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: dBg,
      primaryColor: dPrimary,
      colorScheme: const ColorScheme.dark(
        primary:            dPrimary,
        onPrimary:          Color(0xFF003A75),
        primaryContainer:   dPrimCont,
        onPrimaryContainer: Color(0xFFD6EAFF),
        secondary:          dPrimMid,
        onSecondary:        Colors.white,
        surface:            dSurface,
        onSurface:          dTextHigh,
        onSurfaceVariant:   dTextMed,
        outline:            dBorder,
        outlineVariant:     Color(0xFF1E2A3E),
        error:              Color(0xFFFF6B6B),
        onError:            Color(0xFF3B0000),
        surfaceContainerHighest: dElevated,
      ),
      cardColor: dCard,
      textTheme: base,
      appBarTheme: AppBarTheme(
        backgroundColor: dSurface,
        foregroundColor: dTextHigh,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          color: dTextHigh,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
        iconTheme: const IconThemeData(color: dTextHigh),
        actionsIconTheme: const IconThemeData(color: dTextHigh),
      ),
      cardTheme: CardThemeData(
        color: dCard,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: dBorder, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: dInputFg,
        labelStyle: const TextStyle(color: dTextMed, fontSize: 14),
        hintStyle: const TextStyle(color: dTextLow, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dPrimary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: dPrimary,
          foregroundColor: const Color(0xFF003A75),
          textStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: dPrimary,
          side: const BorderSide(color: dPrimary, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: dPrimary),
      ),
      iconTheme: const IconThemeData(color: dTextMed),
      dividerColor: dBorder,
      dividerTheme: const DividerThemeData(color: dBorder, thickness: 1),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected) ? dPrimary : dTextLow),
        trackColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected) ? dPrimCont : dElevated),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: dElevated,
        labelStyle: TextStyle(color: dTextHigh, fontSize: 13,
            fontFamily: GoogleFonts.plusJakartaSans().fontFamily),
        selectedColor: dPrimary,
        secondaryLabelStyle: const TextStyle(color: Color(0xFF003A75)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: const BorderSide(color: dBorder),
      ),
    );
  }

  // ── Text theme using Plus Jakarta Sans ─────────────────────────────────────
  static TextTheme _baseText(Brightness brightness) {
    final high = brightness == Brightness.light ? lTextHigh : dTextHigh;
    final med  = brightness == Brightness.light ? lTextMed  : dTextMed;
    final low  = brightness == Brightness.light ? lTextLow  : dTextLow;
    return GoogleFonts.plusJakartaSansTextTheme(TextTheme(
      displayLarge:   TextStyle(color: high, fontWeight: FontWeight.w800),
      displayMedium:  TextStyle(color: high, fontWeight: FontWeight.w700),
      headlineLarge:  TextStyle(color: high, fontWeight: FontWeight.w700, fontSize: 24),
      headlineMedium: TextStyle(color: high, fontWeight: FontWeight.w600, fontSize: 20),
      titleLarge:     TextStyle(color: high, fontWeight: FontWeight.w700, fontSize: 18),
      titleMedium:    TextStyle(color: high, fontWeight: FontWeight.w600, fontSize: 16),
      titleSmall:     TextStyle(color: med,  fontWeight: FontWeight.w500, fontSize: 14),
      bodyLarge:      TextStyle(color: high, fontSize: 16, height: 1.5),
      bodyMedium:     TextStyle(color: high, fontSize: 14, height: 1.5),
      bodySmall:      TextStyle(color: med,  fontSize: 12, height: 1.4),
      labelLarge:     TextStyle(color: high, fontWeight: FontWeight.w600, fontSize: 14),
      labelMedium:    TextStyle(color: med,  fontSize: 12),
      labelSmall:     TextStyle(color: low,  fontSize: 11),
    ));
  }
}
