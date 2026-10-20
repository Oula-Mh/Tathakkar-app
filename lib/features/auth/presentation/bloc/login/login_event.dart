import 'package:equatable/equatable.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => <Object?>[];
}

final class LoginEmailChanged extends LoginEvent {
  const LoginEmailChanged(this.value);

  final String value;

  @override
  List<Object?> get props => <Object?>[value];
}

final class LoginPasswordChanged extends LoginEvent {
  const LoginPasswordChanged(this.value);

  final String value;

  @override
  List<Object?> get props => <Object?>[value];
}

final class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
}
