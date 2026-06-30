import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Constructs the Material 3 [ThemeData] using [InvestigatorPalette] tokens.
/// Named [GovernmentDesignTokens] to reflect the professional, trust-first
/// aesthetic described in the CS6750 design brief.
class GovernmentDesignTokens {
  GovernmentDesignTokens._();

  static ThemeData get materialTheme {
    return ThemeData(
      useMaterial3: true,

      colorScheme: const ColorScheme.light(
        primary: InvestigatorPalette.badgeNavy,
        secondary: InvestigatorPalette.slateGray,
        surface: InvestigatorPalette.cardWhite,
        error: InvestigatorPalette.alertRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: InvestigatorPalette.inkDark,
        outline: InvestigatorPalette.ruleLine,
      ),

      scaffoldBackgroundColor: InvestigatorPalette.canvasWash,

      // ── Cards ────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: InvestigatorPalette.cardWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: InvestigatorPalette.ruleLine),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── Top bar ──────────────────────────────────────────────────
      appBarTheme: const AppBarTheme(
        backgroundColor: InvestigatorPalette.cardWhite,
        foregroundColor: InvestigatorPalette.inkDark,
        elevation: 0,
        scrolledUnderElevation: 1,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: InvestigatorPalette.inkDark,
        ),
      ),

      // ── Side rail ────────────────────────────────────────────────
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: pal.sidebarFill,
        selectedIconTheme: const IconThemeData(color: InvestigatorPalette.sidebarActive, size: 24),
        unselectedIconTheme: const IconThemeData(color: InvestigatorPalette.sidebarDormant, size: 24),
        selectedLabelTextStyle: const TextStyle(color: InvestigatorPalette.sidebarActive, fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelTextStyle: const TextStyle(color: InvestigatorPalette.sidebarDormant, fontSize: 12),
        indicatorColor: Colors.white.withOpacity(0.15),
      ),

      // ── Filled buttons ───────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: pal.badgeNavy,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),

      // ── Outlined buttons ─────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: pal.badgeNavy,
          side: const BorderSide(color: InvestigatorPalette.ruleLine),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),

      // ── Text fields ──────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: pal.cardWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: InvestigatorPalette.ruleLine),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: InvestigatorPalette.ruleLine),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: InvestigatorPalette.evidenceBlue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: const TextStyle(color: InvestigatorPalette.inkMuted),
        hintStyle: const TextStyle(color: InvestigatorPalette.inkFaint),
      ),

      // ── Chips ────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: pal.cardOffWhite,
        side: const BorderSide(color: InvestigatorPalette.ruleLine),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        labelStyle: const TextStyle(fontSize: 13, color: InvestigatorPalette.inkDark),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),

      // ── Tabs ─────────────────────────────────────────────────────
      tabBarTheme: const TabBarThemeData(
        labelColor: InvestigatorPalette.badgeNavy,
        unselectedLabelColor: InvestigatorPalette.inkMuted,
        indicatorColor: InvestigatorPalette.badgeNavy,
        labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 14),
      ),

      // ── Data tables ──────────────────────────────────────────────
      dataTableTheme: DataTableThemeData(
        headingTextStyle: const TextStyle(fontWeight: FontWeight.w600, color: InvestigatorPalette.inkDark, fontSize: 13),
        dataTextStyle: const TextStyle(color: InvestigatorPalette.inkDark, fontSize: 13),
        headingRowColor: WidgetStateProperty.all(pal.cardOffWhite),
        dividerThickness: 1,
      ),

      // ── Dividers ─────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(color: InvestigatorPalette.ruleLine, thickness: 1),
    );
  }
}
