import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/entities/app_user.dart';
import '../../../domain/usecases/sign_up_with_email.dart';
import '../../form_inputs/confirm_password_input.dart';
import '../../form_inputs/email_input.dart';
import '../../form_inputs/name_input.dart';
import '../../form_inputs/password_input.dart';
import '../form_submission_status.dart';
import 'register_event.dart';
import 'register_state.dart';

/// Handles registration form validation and Firebase account creation.
///
/// The confirmation input is rebuilt whenever either password field changes,
/// so the match error updates immediately.
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({required SignUpWithEmail signUpWithEmail})
    : _signUpWithEmail = signUpWithEmail,
      super(const RegisterState.initial()) {
    on<RegisterNameChanged>(_onNameChanged);
    on<RegisterEmailChanged>(_onEmailChanged);
    on<RegisterPasswordChanged>(_onPasswordChanged);
    on<RegisterConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<RegisterSubmitted>(_onSubmitted);
  }

  final SignUpWithEmail _signUpWithEmail;

  void _onNameChanged(RegisterNameChanged event, Emitter<RegisterState> emit) {
    emit(
      state.copyWith(
        name: NameInput.dirty(event.value),
        status: FormSubmissionStatus.initial,
        clearErrorMessage: true,
      ),
    );
  }

  void _onEmailChanged(
    RegisterEmailChanged event,
    Emitter<RegisterState> emit,
  ) {
    emit(
      state.copyWith(
        email: EmailInput.dirty(event.value),
        status: FormSubmissionStatus.initial,
        clearErrorMessage: true,
      ),
    );
  }

  void _onPasswordChanged(
    RegisterPasswordChanged event,
    Emitter<RegisterState> emit,
  ) {
    emit(
      state.copyWith(
        password: PasswordInput.dirty(event.value),
        // Revalidate the confirmation against the new password immediately.
        confirmPassword: ConfirmPasswordInput.dirty(
          state.confirmPassword.value,
          password: event.value,
        ),
        status: FormSubmissionStatus.initial,
        clearErrorMessage: true,
      ),
    );
  }

  void _onConfirmPasswordChanged(
    RegisterConfirmPasswordChanged event,
    Emitter<RegisterState> emit,
  ) {
    emit(
      state.copyWith(
        confirmPassword: ConfirmPasswordInput.dirty(
          event.value,
          password: state.password.value,
        ),
        status: FormSubmissionStatus.initial,
        clearErrorMessage: true,
      ),
    );
  }

  Future<void> _onSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    if (state.isSubmitting) {
      return;
    }

    final NameInput name = NameInput.dirty(state.name.value);
    final EmailInput email = EmailInput.dirty(state.email.value);
    final PasswordInput password = PasswordInput.dirty(state.password.value);
    final ConfirmPasswordInput confirmPassword = ConfirmPasswordInput.dirty(
      state.confirmPassword.value,
      password: password.value,
    );

    final bool fieldsValid = Formz.validate(<FormzInput<Object?, Object?>>[
      name,
      email,
      password,
      confirmPassword,
    ]);

    if (!fieldsValid) {
      emit(
        state.copyWith(
          name: name,
          email: email,
          password: password,
          confirmPassword: confirmPassword,
          status: FormSubmissionStatus.initial,
          showErrorMessages: true,
          clearErrorMessage: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        name: name,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        status: FormSubmissionStatus.submitting,
        showErrorMessages: true,
        clearErrorMessage: true,
      ),
    );

    final Either<Failure, AppUser> result = await _signUpWithEmail(
      name: name.value,
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
