import 'package:flutter/material.dart';

/// Centralized color palette derived from the approved Phase 1 UI references.
abstract final class AppColors {
  /// Primary steel teal used for primary buttons, accents, and active states.
  static const Color primary = Color(0xFF41819C);

  /// Darker teal used for gradients and pressed/emphasis accents.
  static const Color primaryDark = Color(0xFF3A7590);

  /// Lighter teal used at the top of primary button gradients.
  static const Color primaryLight = Color(0xFF4B8DA7);

  /// Auth header gradient start (top).
  static const Color headerGradientTop = Color(0xFF4E8AA0);

  /// Auth header gradient end (bottom).
  static const Color headerGradientBottom = Color(0xFF6FA6BF);

  /// Top of the branded splash background.
  static const Color gradientTop = Color(0xFF39728A);

  /// Bottom of the branded splash background.
  static const Color gradientBottom = Color(0xFF5A97B6);

  /// App background light blue.
  static const Color background = Color(0xFFD7E6F1);

  /// White glass-like card/surface color.
  static const Color surface = Color(0xFFFBFDFF);

  /// Slightly deeper white used at the top of the glass card gradient.
  static const Color surfaceMuted = Color(0xFFEDF6FC);

  /// Pale blue surface used by illustration chips and status badges.
  static const Color infoSurface = Color(0xFFDCEBF7);

  /// Primary heading/body text color.
  static const Color textDark = Color(0xFF193D53);

  /// Secondary/muted text color.
  static const Color textMuted = Color(0xFF6B8794);

  /// Slightly deeper muted text used for secondary actions.
  static const Color textSubtle = Color(0xFF5A7F8F);

  /// Light border used by input fields and outlined controls.
  static const Color borderLight = Color(0xFFE1EAF2);

  /// Soft background blob tint used behind content.
  static const Color blobTint = Color(0xFFFFFFFF);

  /// Success banner background.
  static const Color successBackground = Color(0xFFE3F5EC);

  /// Success foreground/text.
  static const Color successForeground = Color(0xFF2E7D57);

  /// Error/validation text and outline color.
  static const Color error = Color(0xFFB2474B);

  /// Inactive onboarding page-indicator dot (neutral gray).
  static const Color dotInactive = Color(0xFFD1D5DB);

  /// White used for labels on primary buttons and text on teal surfaces.
  static const Color onPrimary = Color(0xFFFFFFFF);

  /// Shadow color applied to cards.
  static const Color shadow = Color(0x1F1E4B60);
}
