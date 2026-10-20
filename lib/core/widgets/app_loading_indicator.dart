import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Full-screen centered loading indicator used while resolving startup state.
class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: color ?? AppColors.primary,
        strokeWidth: 3,
      ),
    );
  }
}
