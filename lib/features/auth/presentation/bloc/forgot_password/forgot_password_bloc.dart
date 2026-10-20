import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/usecases/send_password_reset.dart';
import '../../form_inputs/email_input.dart';
import '../form_submission_status.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

/// Handles the forgot/reset-password flow.
///
/// A 60-second countdown starts only after a successful reset-email request;
/// failures never start or reset it. The timer is cancelled on [close].
class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc({required SendPasswordReset sendPasswordReset})
    : _sendPasswordReset = sendPasswordReset,
      super(const ForgotPasswordState.initial()) {
    on<ForgotEmailChanged>(_onEmailChanged);
    on<ForgotSubmitted>(_onSubmitted);
    on<ForgotCountdownTick>(_onCountdownTick);
  }

  /// Seconds the user must wait before resending (approved requirement).
  static const int countdownDurationSeconds = 60;

  final SendPasswordReset _sendPasswordReset;
  Timer? _countdownTimer;

  void _onEmailChanged(
    ForgotEmailChanged event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(
      state.copyWith(
        email: EmailInput.dirty(event.value),
        status: FormSubmissionStatus.initial,
        clearErrorMessage: true,
      ),
    );
  }

  Future<void> _onSubmitted(
    ForgotSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    if (state.isSubmitting) {
      return;
    }

    final EmailInput email = EmailInput.dirty(state.email.value);
    if (!Formz.validate(<FormzInput<Object?, Object?>>[email])) {
      emit(
        state.copyWith(
          email: email,
          showErrorMessages: true,
          status: FormSubmissionStatus.initial,
          clearErrorMessage: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        email: email,
        status: FormSubmissionStatus.submitting,
        showErrorMessages: true,
        clearErrorMessage: true,
      ),
    );

    final Either<Failure, Unit> result = await _sendPasswordReset(
      email: email.value,
    );

    result.fold(
      (Failure failure) => emit(
        // Failure: do not start or reset the countdown.
        state.copyWith(
          status: FormSubmissionStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (Unit _) {
        _startCountdown();
        emit(
          state.copyWith(
            status: FormSubmissionStatus.success,
            resetEmailSent: true,
            countdownSeconds: countdownDurationSeconds,
          ),
        );
      },
    );
  }

  void _onCountdownTick(
    ForgotCountdownTick event,
    Emitter<ForgotPasswordState> emit,
  ) {
    final int next = state.countdownSeconds - 1;
    if (next <= 0) {
      _countdownTimer?.cancel();
      _countdownTimer = null;
      emit(state.copyWith(countdownSeconds: 0));
    } else {
      emit(state.copyWith(countdownSeconds: next));
    }
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => add(const ForgotCountdownTick()),
    );
  }

  @override
  Future<void> close() {
    _countdownTimer?.cancel();
    return super.close();
  }
}
