import 'package:flutter/material.dart';

/// Palette tokens modeled after government/law-enforcement visual identity.
/// Every constant uses a descriptive name tied to its role in the UI
/// so the palette reads as a "design brief" rather than generic color slots.
class InvestigatorPalette {
  InvestigatorPalette._();

  // ── Agency chrome ──────────────────────────────────────────────
  static const Color badgeNavy        = Color(0xFF1B3A5C);
  static const Color badgeNavyMid     = Color(0xFF2C5282);
  static const Color badgeNavyDeep    = Color(0xFF0F2440);

  // ── Neutral tones ──────────────────────────────────────────────
  static const Color slateGray        = Color(0xFF64748B);
  static const Color slateGrayFaded   = Color(0xFF94A3B8);

  // ── Interactive accent ─────────────────────────────────────────
  static const Color evidenceBlue     = Color(0xFF2563EB);

  // ── Canvas layers ──────────────────────────────────────────────
  static const Color canvasWash       = Color(0xFFF1F5F9);
  static const Color cardWhite        = Color(0xFFFFFFFF);
  static const Color cardOffWhite     = Color(0xFFF8FAFC);

  // ── Semantic indicators ────────────────────────────────────────
  static const Color alertRed         = Color(0xFFDC2626);
  static const Color cautionAmber     = Color(0xFFF59E0B);
  static const Color resolvedGreen    = Color(0xFF16A34A);
  static const Color infoSky          = Color(0xFF0EA5E9);

  // ── Typography ─────────────────────────────────────────────────
  static const Color inkDark          = Color(0xFF1E293B);
  static const Color inkMuted         = Color(0xFF64748B);
  static const Color inkFaint         = Color(0xFF94A3B8);

  // ── Structural chrome ──────────────────────────────────────────
  static const Color ruleLine         = Color(0xFFE2E8F0);
  static const Color separatorWash    = Color(0xFFF1F5F9);

  // ── Sidebar ────────────────────────────────────────────────────
  static const Color sidebarFill      = Color(0xFF1B3A5C);
  static const Color sidebarActive    = Color(0xFFFFFFFF);
  static const Color sidebarDormant   = Color(0xFFB0C4DE);
}
