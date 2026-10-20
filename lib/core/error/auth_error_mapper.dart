import '../constants/app_strings.dart';
import 'failure.dart';

/// Maps raw Firebase Authentication error codes to localized [AuthFailure]s.
///
/// The mapper works on plain codes (not Firebase types) so the core layer has
/// no dependency on the Firebase SDK. Raw codes and exceptions are never shown
/// to users.
abstract final class AuthErrorMapper {
  static AuthFailure mapCode(String? code) {
    final String message;
    switch (code) {
      case 'user-not-found':
        message = AppStrings.authUserNotFound;
      case 'wrong-password':
      case 'invalid-credential':
        message = AppStrings.authInvalidCredential;
      case 'email-already-in-use':
        message = AppStrings.authEmailAlreadyInUse;
      case 'weak-password':
        message = AppStrings.authWeakPassword;
      case 'invalid-email':
        message = AppStrings.authInvalidEmail;
      case 'user-disabled':
        message = AppStrings.authUserDisabled;
      case 'too-many-requests':
        message = AppStrings.authTooManyRequests;
      case 'network-request-failed':
        message = AppStrings.authNetworkRequestFailed;
      case 'operation-not-allowed':
        message = AppStrings.authOperationNotAllowed;
      default:
        message = AppStrings.authUnknown;
    }
    return AuthFailure(message, code: code);
  }
}
