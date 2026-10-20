import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Centralized Cairo text styles for the design system.
///
/// The Cairo family is registered in `pubspec.yaml` and applied as the default
/// font in `AppTheme`, so these styles are used for the text hierarchy.
abstract final class AppTypography {
  /// Private constant for the Cairo font family name.
  static const String _fontFamily = 'Cairo';

  /// Large screen title (e.g. auth/onboarding headings).
  static const TextStyle titleLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
    height: 1.35,
  );

  /// Auth header title on the teal gradient.
  static const TextStyle authTitle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 33,
    fontWeight: FontWeight.w700,
    color: AppColors.onPrimary,
    height: 1.3,
  );

  /// Auth header supporting line on the teal gradient.
  static const TextStyle authSubtitle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: Color(0xEBFFFFFF),
    height: 1.4,
  );

  /// Medium section/heading text.
  static const TextStyle titleMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
    height: 1.35,
  );

  /// Primary action button label.
  static const TextStyle button = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 19,
    fontWeight: FontWeight.w600,
    color: AppColors.onPrimary,
    height: 1.2,
  );

  /// Default body text.
  static const TextStyle body = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textDark,
    height: 1.5,
  );

  /// Supporting body copy used under onboarding titles.
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.7,
  );

  /// Secondary/muted body text (descriptions, hints, supporting copy).
  static const TextStyle bodyMuted = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.5,
  );

  /// Small caption text (page indicators, links, footnotes).
  static const TextStyle caption = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.4,
  );

  /// Input label above a text field.
  static const TextStyle inputLabel = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
    height: 1.3,
  );

  /// Input label/field text.
  static const TextStyle input = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textDark,
    height: 1.4,
  );

  /// Validation message shown under a field.
  static const TextStyle error = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 13.5,
    fontWeight: FontWeight.w400,
    color: AppColors.error,
    height: 1.4,
  );
}