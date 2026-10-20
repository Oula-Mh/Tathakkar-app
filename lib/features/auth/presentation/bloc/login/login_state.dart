import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../form_inputs/email_input.dart';
import '../../form_inputs/password_input.dart';
import '../form_submission_status.dart';

class LoginState extends Equatable {
  const LoginState({
    required this.email,
    required this.password,
    required this.status,
    required this.showErrorMessages,
    this.errorMessage,
  });

  const LoginState.initial()
    : email = const EmailInput.pure(),
      password = const PasswordInput.pure(),
      status = FormSubmissionStatus.initial,
      showErrorMessages = false,
      errorMessage = null;

  final EmailInput email;
  final PasswordInput password;
  final FormSubmissionStatus status;

  /// True once the user has attempted submission (drives error display).
  final bool showErrorMessages;

  /// User-facing Arabic failure message when [status] is failure.
  final String? errorMessage;

  bool get isSubmitting => status == FormSubmissionStatus.submitting;

  bool get isValid =>
      Formz.validate(<FormzInput<Object?, Object?>>[email, password]);

  LoginState copyWith({
    EmailInput? email,
    PasswordInput? password,
    FormSubmissionStatus? status,
    bool? showErrorMessages,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      showErrorMessages: showErrorMessages ?? this.showErrorMessages,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => <Object?>[
    email,
    password,
    status,
    showErrorMessages,
    errorMessage,
  ];
}
