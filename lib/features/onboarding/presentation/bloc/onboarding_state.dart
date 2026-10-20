import 'package:equatable/equatable.dart';

/// Number of onboarding slides.
abstract final class OnboardingSlideCount {
  static const int value = 3;
}

class OnboardingState extends Equatable {
  const OnboardingState({
    required this.currentPage,
    required this.isCompleted,
    required this.isSubmitting,
  });

  const OnboardingState.initial()
    : currentPage = 0,
      isCompleted = false,
      isSubmitting = false;

  /// Zero-based index of the visible slide.
  final int currentPage;

  /// True only after the user explicitly skipped or finished.
  final bool isCompleted;

  /// Guards against duplicate taps while completion is being persisted.
  final bool isSubmitting;

  OnboardingState copyWith({
    int? currentPage,
    bool? isCompleted,
    bool? isSubmitting,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      isCompleted: isCompleted ?? this.isCompleted,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => <Object?>[currentPage, isCompleted, isSubmitting];
}
