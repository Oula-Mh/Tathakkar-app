import 'package:equatable/equatable.dart';

/// Authentication resolution status used for startup routing.
enum SessionStatus { unknown, unauthenticated, authenticated }

class SessionState extends Equatable {
  const SessionState({required this.status, required this.onboardingCompleted});

  /// Initial state while nothing has been resolved yet.
SessionState.initial({bool onboardingCompleted = false})
    : status = SessionStatus.unknown,
      onboardingCompleted = onboardingCompleted;

  final SessionStatus status;

  /// Whether the user has explicitly completed or skipped onboarding.
  final bool onboardingCompleted;

  SessionState copyWith({SessionStatus? status, bool? onboardingCompleted}) {
    return SessionState(
      status: status ?? this.status,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }

  @override
  List<Object?> get props => <Object?>[status, onboardingCompleted];
}
