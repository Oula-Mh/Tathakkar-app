import 'package:equatable/equatable.dart';

sealed class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object?> get props => <Object?>[];
}

final class ForgotEmailChanged extends ForgotPasswordEvent {
  const ForgotEmailChanged(this.value);

  final String value;

  @override
  List<Object?> get props => <Object?>[value];
}

final class ForgotSubmitted extends ForgotPasswordEvent {
  const ForgotSubmitted();
}

/// Internal tick advancing the resend countdown (dispatched by the bloc's
/// timer only; never emitted from the UI).
final class ForgotCountdownTick extends ForgotPasswordEvent {
  const ForgotCountdownTick();
}
