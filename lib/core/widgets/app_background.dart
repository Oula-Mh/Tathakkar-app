import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Branded background: light-blue base with soft blurred blobs, optionally
/// with the teal gradient used by the splash screen.
class AppBackground extends StatelessWidget {
  const AppBackground({
    super.key,
    required this.child,
    this.useGradient = false,
  });

  final Widget child;

  /// When true, renders the branded teal gradient (splash-style background)
  /// instead of the light app background.
  final bool useGradient;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        if (useGradient) ...<Widget>[
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  AppColors.gradientTop,
                  AppColors.gradientBottom,
                ],
              ),
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 0.9,
                colors: <Color>[Color(0x1FFFFFFF), Color(0x00FFFFFF)],
              ),
            ),
          ),
        ] else ...<Widget>[
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color(0xFFDDEBF5),
                  AppColors.background,
                  Color(0xFFCFE2EE),
                ],
              ),
            ),
          ),
          const _Blob(
            alignment: Alignment(-0.9, -0.85),
            color: AppColors.blobTint,
            size: 320,
            opacity: 0.55,
          ),
          const _Blob(
            alignment: Alignment(0.95, -0.1),
            color: AppColors.blobTint,
            size: 260,
            opacity: 0.55,
          ),
          const _Blob(
            alignment: Alignment(-0.4, 0.95),
            color: AppColors.blobTint,
            size: 300,
            opacity: 0.45,
          ),
        ],
        child,
      ],
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({
    required this.alignment,
    required this.color,
    required this.size,
    this.opacity = 0.6,
  });

  final Alignment alignment;
  final Color color;
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: <Color>[
              color.withValues(alpha: opacity),
              color.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}
