import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';

/// Pill-shaped primary action button with an optional inline loading state.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final bool enabled = onPressed != null && !isLoading;
    final BorderRadius radius = BorderRadius.circular(AppRadius.pill);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient:
            enabled
                ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    AppColors.primaryLight,
                    AppColors.primaryDark,
                  ],
                )
                : null,
        color: enabled ? null : AppColors.primary.withValues(alpha: 0.38),
        borderRadius: radius,
        boxShadow:
            enabled
                ? <BoxShadow>[
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.28),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ]
                : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: radius,
          child: SizedBox(
            height: 50,
            child: Center(
              child:
                  isLoading
                      ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: AppColors.onPrimary,
                        ),
                      )
                      : Text(
                        label,
                        style: AppTypography.button.copyWith(
                          color: AppColors.onPrimary.withValues(
                            alpha: enabled ? 1 : 0.9,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
            ),
          ),
        ),
      ),
    );
  }
}
