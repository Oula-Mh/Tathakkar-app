import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/capsule_icon.dart';

/// Rounded translucent backdrop holding each onboarding illustration.
class OnboardingVisualPanel extends StatelessWidget {
  const OnboardingVisualPanel({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.panel),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.panel),
        child: child,
      ),
    );
  }
}

/// Slide 1: a medication reminder card with success and snooze badges.
class OnboardingReminderVisual extends StatelessWidget {
  const OnboardingReminderVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: SizedBox(
          width: 292,
          height: 372,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 4,
                left: 58,
                width: 176,
                bottom: 40,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 18),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 30,
                        offset: Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      Text(
                        AppStrings.previewEarlyTime,
                        style: AppTypography.caption,
                      ),
                      const Spacer(flex: 3),
                      const CapsuleIcon(
                        width: 88,
                        height: 40,
                        angle: -0.85,
                        leftColor: AppColors.primary,
                        rightColor: AppColors.onPrimary,
                      ),
                      const Spacer(flex: 3),
                      Text(
                        AppStrings.previewMedicineName,
                        style: AppTypography.titleMedium.copyWith(fontSize: 19),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        AppStrings.previewDose,
                        style: AppTypography.caption.copyWith(fontSize: 13.5),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(flex: 4),
                      Container(
                        height: 36,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: <Color>[
                              AppColors.primaryLight,
                              AppColors.primaryDark,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          AppStrings.previewTakenAction,
                          style: AppTypography.button.copyWith(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 30,
                right: 0,
                child: const _PreviewChip(
                  label: AppStrings.previewConfirmed,
                  showCheck: true,
                ),
              ),
              Positioned(
                bottom: 44,
                left: 0,
                child: const _PreviewChip(label: AppStrings.previewReminder),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreviewChip extends StatelessWidget {
  const _PreviewChip({required this.label, this.showCheck = false});

  final String label;
  final bool showCheck;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            label,
            style: AppTypography.bodyMuted.copyWith(
              color: AppColors.textDark,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          if (showCheck) ...<Widget>[
            const SizedBox(width: AppSpacing.xxs),
            const Icon(
              Icons.check_rounded,
              size: 16,
              color: AppColors.successForeground,
            ),
          ],
        ],
      ),
    );
  }
}

/// Slide 2: a short medication list with confirmed and upcoming states.
class OnboardingMedicinesVisual extends StatelessWidget {
  const OnboardingMedicinesVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: SizedBox(
          width: 292,
          height: 372,
          child: Column(
            children: <Widget>[
              const SizedBox(height: AppSpacing.xs),
              const _MedicineRow(
                name: AppStrings.previewMedicineShort,
                time: AppStrings.previewMorningTime,
                confirmed: true,
              ),
              const SizedBox(height: AppSpacing.sm),
              const _MedicineRow(
                name: AppStrings.previewMedicineSecond,
                time: AppStrings.previewNoonTime,
              ),
              const SizedBox(height: AppSpacing.sm),
              const _MedicineRow(
                name: AppStrings.previewMedicineThird,
                time: AppStrings.previewEveningTime,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MedicineRow extends StatelessWidget {
  const _MedicineRow({
    required this.name,
    required this.time,
    this.confirmed = false,
  });

  final String name;
  final String time;
  final bool confirmed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 232,
      constraints: const BoxConstraints(minHeight: 76),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 22,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.infoSurface,
              borderRadius: BorderRadius.circular(15),
            ),
            alignment: Alignment.center,
            child: const CapsuleIcon(
              width: 30,
              height: 14,
              angle: -0.85,
              leftColor: AppColors.primary,
              rightColor: AppColors.onPrimary,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: AppTypography.caption.copyWith(fontSize: 12.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          _StatusChip(confirmed: confirmed),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.confirmed});

  final bool confirmed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 44,
      decoration: BoxDecoration(
        color: confirmed ? AppColors.successBackground : AppColors.infoSurface,
        borderRadius: BorderRadius.circular(15),
      ),
      child:
          confirmed
              ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.check_rounded,
                    size: 15,
                    color: AppColors.successForeground,
                  ),
                  Text(
                    AppStrings.previewConfirmed,
                    style: AppTypography.caption.copyWith(
                      fontSize: 11.5,
                      height: 1.1,
                      color: AppColors.successForeground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
              : Center(
                child: Text(
                  AppStrings.previewUpcoming,
                  style: AppTypography.caption.copyWith(
                    fontSize: 12.5,
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
    );
  }
}

/// Slide 3: two linked family profiles with a confirmation badge.
class OnboardingFamilyVisual extends StatelessWidget {
  const OnboardingFamilyVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: SizedBox(
          width: 292,
          height: 372,
          child: Stack(
            children: <Widget>[
              const Positioned(
                top: 0,
                right: 6,
                child: _ProfileCard(
                  name: AppStrings.previewProfileOne,
                  initial: 'أ',
                ),
              ),
              const Positioned(
                bottom: 34,
                left: 6,
                child: _ProfileCard(
                  name: AppStrings.previewProfileTwo,
                  initial: 'أ',
                ),
              ),
              Positioned(
                top: 104,
                left: 132,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: <Color>[
                        AppColors.primaryLight,
                        AppColors.primaryDark,
                      ],
                    ),
                    border: Border.all(color: AppColors.onPrimary, width: 2),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 14,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 22,
                    color: AppColors.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.name, required this.initial});

  final String name;
  final String initial;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104,
      height: 116,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  AppColors.headerGradientBottom,
                  AppColors.primaryDark,
                ],
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              initial,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: AppColors.onPrimary,
                height: 1,
              ),
            ),
          ),
          const Spacer(),
          Text(
            name,
            style: AppTypography.body.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }
}
