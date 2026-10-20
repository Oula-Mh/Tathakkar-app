import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'app_background.dart';
import 'capsule_icon.dart';

/// Branded splash shown while the session state is being resolved.
///
/// Reproduces the approved splash reference: teal gradient, centered
/// translucent logo mark with a check badge, app name and wordmark.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        useGradient: true,
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const _BrandMark(),
                const SizedBox(height: 26),
                const Text(
                  AppStrings.appName,
                  style: TextStyle(
                    fontSize: 46,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onPrimary,
                    height: 1.15,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 12),
                Text(
                  AppStrings.appTagline,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.onPrimary.withValues(alpha: 0.9),
                    letterSpacing: 6,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Translucent capsule-with-check logo mark composed from tokens.
class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 108,
      height: 108,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.onPrimary.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: AppColors.onPrimary.withValues(alpha: 0.45),
                  width: 1.5,
                ),
              ),
              child: const Center(
                child: CapsuleIcon(
                  width: 72,
                  height: 32,
                  angle: -0.85,
                  leftColor: AppColors.primary,
                  rightColor: AppColors.onPrimary,
                ),
              ),
            ),
          ),
          Positioned(
            top: -10,
            right: -10,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.onPrimary.withValues(alpha: 0.22),
                border: Border.all(
                  color: AppColors.onPrimary.withValues(alpha: 0.85),
                  width: 1.8,
                ),
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 20,
                color: AppColors.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
