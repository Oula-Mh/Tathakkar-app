import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../form_inputs/confirm_password_input.dart';
import '../../form_inputs/email_input.dart';
import '../../form_inputs/name_input.dart';
import '../../form_inputs/password_input.dart';
import '../form_submission_status.dart';

class RegisterState extends Equatable {
  const RegisterState({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.status,
    required this.showErrorMessages,
    this.errorMessage,
  });

  const RegisterState.initial()
    : name = const NameInput.pure(),
      email = const EmailInput.pure(),
      password = const PasswordInput.pure(),
      confirmPassword = const ConfirmPasswordInput.pure(),
      status = FormSubmissionStatus.initial,
      showErrorMessages = false,
      errorMessage = null;

  final NameInput name;
  final EmailInput email;
  final PasswordInput password;

  final ConfirmPasswordInput confirmPassword;

  final FormSubmissionStatus status;
  final bool showErrorMessages;
  final String? errorMessage;

  bool get isSubmitting => status == FormSubmissionStatus.submitting;

  bool get isValid => Formz.validate(<FormzInput<Object?, Object?>>[
    name,
    email,
    password,
    confirmPassword,
  ]);

  RegisterState copyWith({
    NameInput? name,
    EmailInput? email,
    PasswordInput? password,
    ConfirmPasswordInput? confirmPassword,
    FormSubmissionStatus? status,
    bool? showErrorMessages,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return RegisterState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      status: status ?? this.status,
      showErrorMessages: showErrorMessages ?? this.showErrorMessages,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => <Object?>[
    name,
    email,
    password,
    confirmPassword,
    status,
    showErrorMessages,
    errorMessage,
  ];
}
