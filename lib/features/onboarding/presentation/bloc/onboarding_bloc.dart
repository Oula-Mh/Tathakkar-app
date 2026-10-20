import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/storage/onboarding_status_store.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

/// Presentation-only bloc for onboarding navigation and completion.
///
/// Depends on the shared [OnboardingStatusStore]; the completion flag is
/// written only when the user explicitly skips or finishes — never on app
/// open or page changes.
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc({required OnboardingStatusStore onboardingStatusStore})
    : _onboardingStatusStore = onboardingStatusStore,
      super(const OnboardingState.initial()) {
    on<OnboardingPageChanged>(_onPageChanged);
    on<OnboardingNextPressed>(_onNextPressed);
    on<OnboardingSkipped>(_onCompletionRequested);
    on<OnboardingFinished>(_onCompletionRequested);
  }

  final OnboardingStatusStore _onboardingStatusStore;

  void _onPageChanged(
    OnboardingPageChanged event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(currentPage: event.pageIndex));
  }

  void _onNextPressed(
    OnboardingNextPressed event,
    Emitter<OnboardingState> emit,
  ) {
    final int next = state.currentPage + 1;
    if (next < OnboardingSlideCount.value) {
      emit(state.copyWith(currentPage: next));
    }
  }

  Future<void> _onCompletionRequested(
    OnboardingEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    if (state.isSubmitting || state.isCompleted) {
      return;
    }
    emit(state.copyWith(isSubmitting: true));
    await _onboardingStatusStore.markCompleted();
    emit(state.copyWith(isCompleted: true, isSubmitting: false));
  }
}
