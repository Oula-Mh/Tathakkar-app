import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import '../../features/auth/domain/entities/app_user.dart';
import '../../features/auth/domain/usecases/watch_auth_state.dart';
import '../storage/onboarding_status_store.dart';
import 'session_event.dart';
import 'session_state.dart';

/// Coordinates startup routing: observes the onboarding-completed flag and
/// the Firebase authentication-state stream, and exposes one resolved state
/// that the GoRouter redirect consumes.
class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionBloc({
    required OnboardingStatusStore onboardingStatusStore,
    required WatchAuthState watchAuthState,
    Duration minimumSplashDuration = const Duration(milliseconds: 2500),
  })  : _onboardingStatusStore = onboardingStatusStore,
     super(
       SessionState.initial(
         onboardingCompleted: onboardingStatusStore.isCompleted,
       ),
     ) {
    on<SessionStarted>(_onStarted);
    on<SessionOnboardingCompleted>(_onOnboardingCompleted);
    on<SessionAuthStateChanged>(_onAuthStatusChanged);

    // Keeps the splash visible for a minimum duration even when the auth
    // stream resolves immediately.
    _splashTimer = Timer(minimumSplashDuration, _onSplashDelayElapsed);
    _authSubscription = watchAuthState().listen(_onAuthStateChanged);
  }

  final OnboardingStatusStore _onboardingStatusStore;
  late final Timer _splashTimer;
  StreamSubscription<AppUser?>? _authSubscription;
  bool _splashDelayElapsed = false;
  SessionStatus? _pendingStatus;

  void _onSplashDelayElapsed() {
    _splashDelayElapsed = true;
    final SessionStatus? status = _pendingStatus;
    _pendingStatus = null;
    if (status != null) {
      add(SessionAuthStateChanged(status));
    }
  }

 void _onStarted(
  SessionStarted event,
  Emitter<SessionState> emit,
) {
  final bool completed = _onboardingStatusStore.isCompleted;

  debugPrint('[SessionBloc] Startup read: $completed');

  emit(state.copyWith(onboardingCompleted: completed));

  debugPrint(
    '[SessionBloc] State after startup: '
    '${state.onboardingCompleted}',
  );
}

void _onOnboardingCompleted(
  SessionOnboardingCompleted event,
  Emitter<SessionState> emit,
) {
  final bool completed = _onboardingStatusStore.isCompleted;

  debugPrint('[SessionBloc] Completion event received');
  debugPrint('[SessionBloc] Store value: $completed');

  emit(state.copyWith(onboardingCompleted: completed));

  debugPrint(
    '[SessionBloc] State after completion: '
    '${state.onboardingCompleted}',
  );
}

  void _onAuthStatusChanged(
    SessionAuthStateChanged event,
    Emitter<SessionState> emit,
  ) {
    if (!_splashDelayElapsed) {
      // Hold the splash until its minimum display duration has elapsed.
      _pendingStatus = event.status;
      return;
    }
    emit(state.copyWith(status: event.status));
  }

  void _onAuthStateChanged(AppUser? user) {
    add(
      SessionAuthStateChanged(
        user == null
            ? SessionStatus.unauthenticated
            : SessionStatus.authenticated,
      ),
    );
  }

  @override
  Future<void> close() {
    _splashTimer.cancel();
    _authSubscription?.cancel();
    return super.close();
  }
}
