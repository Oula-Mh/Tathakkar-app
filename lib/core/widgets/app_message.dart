import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';

/// Displays one-off feedback messages (snackbars) so BLoCs and pages never
/// build these imperatively in a `BlocBuilder`.
abstract final class AppMessages {
  static void show(
    BuildContext context, {
    required String message,
    bool isError = false,
  }) {
    final ScaffoldMessengerState? messenger = ScaffoldMessenger.maybeOf(
      context,
    );
    messenger
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor:
              isError ? AppColors.error : AppColors.successBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
          ),
          content: Text(
            message,
            style: AppTypography.body.copyWith(
              color:
                  isError ? AppColors.onPrimary : AppColors.successForeground,
            ),
          ),
        ),
      );
  }
}
