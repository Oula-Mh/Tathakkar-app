import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../form_inputs/email_input.dart';
import '../form_submission_status.dart';

class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({
    required this.email,
    required this.status,
    required this.showErrorMessages,
    required this.countdownSeconds,
    required this.resetEmailSent,
    this.errorMessage,
  });

  const ForgotPasswordState.initial()
    : email = const EmailInput.pure(),
      status = FormSubmissionStatus.initial,
      showErrorMessages = false,
      countdownSeconds = 0,
      resetEmailSent = false,
      errorMessage = null;

  final EmailInput email;
  final FormSubmissionStatus status;
  final bool showErrorMessages;

  /// Seconds remaining until resend is allowed. Non-zero only after a
  /// successful reset-email request.
  final int countdownSeconds;

  /// True once a reset email has been sent successfully at least once.
  final bool resetEmailSent;

  final String? errorMessage;

  bool get isSubmitting => status == FormSubmissionStatus.submitting;

  /// Resend is blocked while the countdown is running.
  bool get resendEnabled => countdownSeconds <= 0;

  bool get isValid => Formz.validate(<FormzInput<Object?, Object?>>[email]);

  ForgotPasswordState copyWith({
    EmailInput? email,
    FormSubmissionStatus? status,
    bool? showErrorMessages,
    int? countdownSeconds,
    bool? resetEmailSent,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      status: status ?? this.status,
      showErrorMessages: showErrorMessages ?? this.showErrorMessages,
      countdownSeconds: countdownSeconds ?? this.countdownSeconds,
      resetEmailSent: resetEmailSent ?? this.resetEmailSent,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => <Object?>[
    email,
    status,
    showErrorMessages,
    countdownSeconds,
    resetEmailSent,
    errorMessage,
  ];
}
