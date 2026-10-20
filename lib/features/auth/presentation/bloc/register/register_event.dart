import 'package:equatable/equatable.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => <Object?>[];
}

final class RegisterNameChanged extends RegisterEvent {
  const RegisterNameChanged(this.value);

  final String value;

  @override
  List<Object?> get props => <Object?>[value];
}

final class RegisterEmailChanged extends RegisterEvent {
  const RegisterEmailChanged(this.value);

  final String value;

  @override
  List<Object?> get props => <Object?>[value];
}

final class RegisterPasswordChanged extends RegisterEvent {
  const RegisterPasswordChanged(this.value);

  final String value;

  @override
  List<Object?> get props => <Object?>[value];
}

final class RegisterConfirmPasswordChanged extends RegisterEvent {
  const RegisterConfirmPasswordChanged(this.value);

  final String value;

  @override
  List<Object?> get props => <Object?>[value];
}

final class RegisterSubmitted extends RegisterEvent {
  const RegisterSubmitted();
}
