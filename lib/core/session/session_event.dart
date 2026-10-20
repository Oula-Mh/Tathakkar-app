import 'package:equatable/equatable.dart';

import 'session_state.dart';

sealed class SessionEvent extends Equatable {
  const SessionEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Dispatched once at startup to resolve onboarding status and begin
/// observing authentication state.
final class SessionStarted extends SessionEvent {
  const SessionStarted();
}

/// Dispatched when the user explicitly completes or skips onboarding.
final class SessionOnboardingCompleted extends SessionEvent {
  const SessionOnboardingCompleted();
}

/// Internal session event forwarded when the Firebase authentication stream
/// emits a new user (or null). Declared here so it stays in the sealed
/// hierarchy's library while remaining private to the session feature.
final class SessionAuthStateChanged extends SessionEvent {
  const SessionAuthStateChanged(this.status);

  final SessionStatus status;

  @override
  List<Object?> get props => <Object?>[status];
}
