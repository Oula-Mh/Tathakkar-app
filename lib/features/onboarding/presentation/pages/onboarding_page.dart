import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/responsive/responsive_layout.dart';
import '../../../../core/session/session_bloc.dart';
import '../../../../core/session/session_event.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../bloc/onboarding_state.dart';
import '../widgets/onboarding_slide.dart';
import '../widgets/onboarding_visuals.dart';

/// Onboarding screen: three slides with a pill page indicator, skip on the
/// first two slides, and finish on the last slide.
///
/// The bloc is provided as a factory from the DI container; on completion it
/// notifies the [SessionBloc], whose redirect moves the user to login.
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OnboardingBloc>(
      create: (BuildContext context) => getIt<OnboardingBloc>(),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatefulWidget {
  const _OnboardingView();

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    context.read<OnboardingBloc>().add(OnboardingPageChanged(index));
  }

  void _onNext() {
    context.read<OnboardingBloc>().add(const OnboardingNextPressed());
  }

  void _onSkip() {
    context.read<OnboardingBloc>().add(const OnboardingSkipped());
  }

  void _onFinish() {
    context.read<OnboardingBloc>().add(const OnboardingFinished());
  }

  void _animateToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingState>(
      listenWhen:
          (OnboardingState previous, OnboardingState current) =>
              previous.currentPage != current.currentPage ||
              previous.isCompleted != current.isCompleted,
      listener: (BuildContext context, OnboardingState state) {
        if (state.isCompleted) {
          // One-off effect: hand control back to the session/router layer.
          context.read<SessionBloc>().add(const SessionOnboardingCompleted());
        } else {
          // The bloc advanced the page (Next action): animate the PageView.
          _animateToPage(state.currentPage);
        }
      },
      child: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (BuildContext context, OnboardingState state) {
          final bool isLastPage =
              state.currentPage == OnboardingSlideCount.value - 1;
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: AppBackground(
                child: SafeArea(
                  child: ResponsiveLayout(
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: AppSpacing.xs),
                        SizedBox(
                          height: 44,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                            ),
                            child: Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child:
                                  isLastPage
                                      ? const SizedBox.shrink()
                                      : TextButton(
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: AppSpacing.sm,
                                          ),
                                          minimumSize: Size.zero,
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        onPressed:
                                            state.isSubmitting ? null : _onSkip,
                                        child: Text(
                                          AppStrings.onboardingSkip,
                                          style: AppTypography.body.copyWith(
                                            color: AppColors.textSubtle,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: PageView(
                            controller: _pageController,
                            onPageChanged: _onPageChanged,
                            children: const <Widget>[
                              OnboardingVisualPanel(
                                child: OnboardingReminderVisual(),
                              ),
                              OnboardingVisualPanel(
                                child: OnboardingMedicinesVisual(),
                              ),
                              OnboardingVisualPanel(
                                child: OnboardingFamilyVisual(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.xs,
                          ),
                          child: SmoothPageIndicator(
                            controller: _pageController,
                            count: OnboardingSlideCount.value,
                            effect: const ExpandingDotsEffect(
                              activeDotColor: AppColors.primary,
                              dotColor: AppColors.dotInactive,
                              dotHeight: 8,
                              dotWidth: 8,
                              expansionFactor: 3,
                              spacing: AppSpacing.xs,
                            ),
                            textDirection: TextDirection.rtl,
                            onDotClicked: _animateToPage,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xxl,
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: OnboardingSlide(
                              key: ValueKey<int>(state.currentPage),
                              title:
                                  state.currentPage == 0
                                      ? AppStrings.onboardingTitle1
                                      : state.currentPage == 1
                                      ? AppStrings.onboardingTitle2
                                      : AppStrings.onboardingTitle3,
                              body:
                                  state.currentPage == 0
                                      ? AppStrings.onboardingBody1
                                      : state.currentPage == 1
                                      ? AppStrings.onboardingBody2
                                      : AppStrings.onboardingBody3,
                            ),
                          ),
                        ),
                        const Spacer(flex: 2),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.lg,
                            AppSpacing.sm,
                            AppSpacing.lg,
                            AppSpacing.xl,
                          ),
                          child: PrimaryButton(
                            label:
                                isLastPage
                                    ? AppStrings.onboardingFinish
                                    : AppStrings.onboardingNext,
                            onPressed:
                                state.isSubmitting
                                    ? null
                                    : (isLastPage ? _onFinish : _onNext),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
