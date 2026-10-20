import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/circle_back_button.dart';

/// Teal gradient header used by the auth screens, with the screen title,
/// supporting line, and the reference navigation affordances.
class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.showBackButton = true,
  });

  final String title;
  final String subtitle;

  /// Whether the back affordance is rendered.
  final bool showBackButton;

  /// Header height in logical pixels, including the part the form card
  /// overlaps.
  static const double height = 236;

  @override
  Widget build(BuildContext context) {
    // Extend the gradient behind the status bar while keeping the header
    // content at its original offset.
    final double topInset = MediaQuery.paddingOf(context).top;

    return SizedBox(
      height: height + topInset,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(36),
              ),
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      AppColors.headerGradientTop,
                      AppColors.headerGradientBottom,
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (showBackButton)
            Positioned(
              top: topInset + 20,
              right: 20,
              child: CircleBackButton(
                icon: Icons.arrow_forward,
                filled: false,
                onPressed: () => context.pushReplacement(AppRoutes.login),
              ),
            ),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(top: topInset + 92, left: 32, right: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    title,
                    style: AppTypography.authTitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    subtitle,
                    style: AppTypography.authSubtitle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
