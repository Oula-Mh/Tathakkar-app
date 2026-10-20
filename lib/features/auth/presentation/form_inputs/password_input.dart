import 'package:formz/formz.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/value_validators.dart';

enum PasswordValidationError { empty, tooShort }

/// Password input shared by login and registration forms.
class PasswordInput extends FormzInput<String, PasswordValidationError> {
  const PasswordInput.pure() : super.pure('');

  const PasswordInput.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return PasswordValidationError.empty;
    }
    if (!ValueValidators.isPasswordLongEnough(value)) {
      return PasswordValidationError.tooShort;
    }
    return null;
  }
}

extension PasswordValidationErrorMessages on PasswordValidationError {
  String get message => switch (this) {
    PasswordValidationError.empty => AppStrings.passwordRequired,
    PasswordValidationError.tooShort => AppStrings.passwordTooShort,
  };
}
