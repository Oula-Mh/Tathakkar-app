/// Application-level failure representation.
///
/// Failures carry a user-facing [message] already translated to Arabic.
/// [code] and [type] are for diagnostics and branching only and must never be
/// shown raw to users.
enum FailureType { validation, auth, network, unknown }

class Failure {
  const Failure(this.message, {this.type = FailureType.unknown, this.code});

  /// User-facing, already localized message.
  final String message;

  /// Category of the failure.
  final FailureType type;

  /// Optional diagnostic code (e.g. a Firebase error code). Never shown.
  final String? code;
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message) : super(type: FailureType.validation);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.code})
    : super(type: FailureType.auth);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message)
    : super(type: FailureType.network, code: 'network-request-failed');
}
