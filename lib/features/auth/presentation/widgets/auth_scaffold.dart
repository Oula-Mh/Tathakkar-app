import 'package:flutter/material.dart';

import '../../../../core/responsive/responsive_layout.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_background.dart';
import 'auth_form_card.dart';
import 'auth_header.dart';

/// Shared auth screen layout: a fixed gradient header with the form card
/// overlapping it. Only the form content scrolls.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.showBackButton = true,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final bool showBackButton;

  /// How far the form card overlaps the header.
  static const double _cardOverlap = 44;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          // The header extends behind the status bar; its content keeps the
          // system spacing internally.
          top: false,
          child: ResponsiveLayout(
            child: Column(
              children: <Widget>[
                AuthHeader(
                  title: title,
                  subtitle: subtitle,
                  showBackButton: showBackButton,
                ),
                Expanded(
                  child: Stack(
                    // The card's top 44 px paint over the header, so the
                    // overlap must not be clipped.
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      Positioned(
                        top: -_cardOverlap,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                            ),
                            child: AuthFormCard(
                              child: ListView(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                children: <Widget>[child],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
