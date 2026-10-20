import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Title and supporting copy for a single onboarding slide.
class OnboardingSlide extends StatelessWidget {
  const OnboardingSlide({super.key, required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          title,
          style: AppTypography.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(body, style: AppTypography.bodyLarge, textAlign: TextAlign.center),
      ],
    );
  }
}
