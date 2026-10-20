import 'package:formz/formz.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/value_validators.dart';

enum EmailValidationError { empty, invalid }

/// Email input shared by login, registration, and password reset forms.
class EmailInput extends FormzInput<String, EmailValidationError> {
  const EmailInput.pure() : super.pure('');

  const EmailInput.dirty([super.value = '']) : super.dirty();

  @override
  EmailValidationError? validator(String value) {
    if (!ValueValidators.isNotEmpty(value)) {
      return EmailValidationError.empty;
    }
    if (!ValueValidators.isValidEmail(value)) {
      return EmailValidationError.invalid;
    }
    return null;
  }
}

extension EmailValidationErrorMessages on EmailValidationError {
  String get message => switch (this) {
    EmailValidationError.empty => AppStrings.emailRequired,
    EmailValidationError.invalid => AppStrings.emailInvalid,
  };
}
