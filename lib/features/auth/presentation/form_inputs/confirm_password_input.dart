import 'package:formz/formz.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/value_validators.dart';

enum ConfirmPasswordValidationError { empty, mismatch }

/// Password-confirmation input that revalidates whenever the source password
/// or the confirmation value changes (the bloc rebuilds it on either change).
class ConfirmPasswordInput
    extends FormzInput<String, ConfirmPasswordValidationError> {
  const ConfirmPasswordInput.pure({this.password = ''}) : super.pure('');

  const ConfirmPasswordInput.dirty(super.value, {required this.password})
    : super.dirty();

  /// The current password value the confirmation is checked against.
  final String password;

  @override
  ConfirmPasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return ConfirmPasswordValidationError.empty;
    }
    if (!ValueValidators.passwordsMatch(password, value)) {
      return ConfirmPasswordValidationError.mismatch;
    }
    return null;
  }
}

extension ConfirmPasswordValidationErrorMessages
    on ConfirmPasswordValidationError {
  String get message => switch (this) {
    ConfirmPasswordValidationError.empty => AppStrings.confirmPasswordRequired,
    ConfirmPasswordValidationError.mismatch => AppStrings.passwordMismatch,
  };
}
