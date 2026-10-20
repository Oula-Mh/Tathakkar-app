import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/entities/app_user.dart';
import '../../../domain/usecases/sign_in_with_email.dart';
import '../../form_inputs/email_input.dart';
import '../../form_inputs/password_input.dart';
import '../form_submission_status.dart';
import 'login_event.dart';
import 'login_state.dart';

/// Handles login form validation and Firebase sign-in.
///
/// Duplicate submissions are ignored while a request is in progress; the
/// session bloc observes the auth stream and updates routing on success.
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required SignInWithEmail signInWithEmail})
    : _signInWithEmail = signInWithEmail,
      super(const LoginState.initial()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  final SignInWithEmail _signInWithEmail;

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        email: EmailInput.dirty(event.value),
        status: FormSubmissionStatus.initial,
        clearErrorMessage: true,
      ),
    );
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(
      state.copyWith(
        password: PasswordInput.dirty(event.value),
        status: FormSubmissionStatus.initial,
        clearErrorMessage: true,
      ),
    );
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state.isSubmitting) {
      return;
    }

    final EmailInput email = EmailInput.dirty(state.email.value);
    final PasswordInput password = PasswordInput.dirty(state.password.value);

    if (!Formz.validate(<FormzInput<Object?, Object?>>[email, password])) {
      emit(
        state.copyWith(
          email: email,
          password: password,
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
        password: password,
        status: FormSubmissionStatus.submitting,
        showErrorMessages: true,
        clearErrorMessage: true,
      ),
    );

    final Either<Failure, AppUser> result = await _signInWithEmail(
      email: email.value,
      password: password.value,
    );

    result.fold(
      (Failure failure) => emit(
        state.copyWith(
          status: FormSubmissionStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (AppUser _) => emit(state.copyWith(status: FormSubmissionStatus.success)),
    );
  }
}
