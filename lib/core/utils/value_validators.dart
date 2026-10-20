/// Shared validation predicates used by formz inputs across features.
///
/// These are pure checks only; localized messages are mapped in the
/// presentation layer where the validation errors are consumed.
abstract final class ValueValidators {
  static final RegExp _email = RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]+$");

  /// Minimum password length accepted by the app (matches Firebase minimum).
  static const int minPasswordLength = 6;

  /// Returns true when [value] is a syntactically valid email address.
  static bool isValidEmail(String value) => _email.hasMatch(value.trim());

  /// Returns true when [value] has any non-whitespace content.
  static bool isNotEmpty(String value) => value.trim().isNotEmpty;

  /// Returns true when [value] meets the minimum password length.
  static bool isPasswordLongEnough(String value) =>
      value.length >= minPasswordLength;

  /// Returns true when both passwords match.
  static bool passwordsMatch(String password, String confirmation) =>
      password == confirmation;
}
