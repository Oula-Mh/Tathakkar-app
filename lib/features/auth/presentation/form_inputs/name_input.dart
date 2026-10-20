import 'package:formz/formz.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/value_validators.dart';

enum NameValidationError { empty }

/// Full-name input used by the registration form.
class NameInput extends FormzInput<String, NameValidationError> {
  const NameInput.pure() : super.pure('');

  const NameInput.dirty([super.value = '']) : super.dirty();

  @override
  NameValidationError? validator(String value) {
    if (!ValueValidators.isNotEmpty(value)) {
      return NameValidationError.empty;
    }
    return null;
  }
}

extension NameValidationErrorMessages on NameValidationError {
  String get message => switch (this) {
    NameValidationError.empty => AppStrings.nameRequired,
  };
}
