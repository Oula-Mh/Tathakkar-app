import 'package:flutter/material.dart';

/// Circular icon action used in the auth header (back/continue affordance).
///
/// The icon direction is fixed (not mirrored) because the approved references
/// place the left arrow on the back chip and the right arrow in the circle.
class CircleBackButton extends StatelessWidget {
  const CircleBackButton({
    super.key,
    this.onPressed,
    this.icon = Icons.arrow_back,
    this.filled = true,
  });

  final VoidCallback? onPressed;
  final IconData icon;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              filled
                  ? Colors.white.withValues(alpha: 0.18)
                  : Colors.transparent,
          border: Border.all(color: Colors.white.withValues(alpha: 0.55)),
        ),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}
