import 'package:flutter/material.dart';

/// Centers its [child] and constrains it to a phone-first maximum width so
/// content stays readable and consistent on tablets and large screens.
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({super.key, required this.child});

  /// Maximum content width before the layout stops stretching.
  static const double maxWidth = 480;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
