import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tathakkar/core/error/auth_error_mapper.dart';
import 'package:tathakkar/core/error/failure.dart';
import 'package:tathakkar/core/session/session_bloc.dart';
import 'package:tathakkar/core/session/session_event.dart';
import 'package:tathakkar/core/session/session_state.dart';
import 'package:tathakkar/core/storage/onboarding_status_store.dart';
import 'package:tathakkar/features/auth/domain/entities/app_user.dart';
import 'package:tathakkar/features/auth/domain/usecases/watch_auth_state.dart';

class MockOnboardingStatusStore extends Mock implements OnboardingStatusStore {}

class MockWatchAuthState extends Mock implements WatchAuthState {}

void main() {
  late MockOnboardingStatusStore store;
  late MockWatchAuthState watchAuthState;
  late StreamController<AppUser?> authController;
  late bool completed;

  const AppUser user = AppUser(uid: 'uid-1');

  setUp(() {
    store = MockOnboardingStatusStore();
    watchAuthState = MockWatchAuthState();
    authController = StreamController<AppUser?>.broadcast();
    when(() => store.isCompleted).thenAnswer((_) => completed);
    when(() => watchAuthState()).thenAnswer((_) => authController.stream);
  });

  tearDown(() async {
    await authController.close();
  });

  blocTest<SessionBloc, SessionState>(
    'starts with unknown status and false onboarding flag',
    build:
        () => SessionBloc(
          onboardingStatusStore: store,
          watchAuthState: watchAuthState,
          minimumSplashDuration: Duration.zero,
        ),
    expect: () => const <SessionState>[],
  );

  blocTest<SessionBloc, SessionState>(
    'SessionStarted resolves the onboarding flag from the store',
    build: () {
      when(() => store.isCompleted).thenReturn(true);
      return SessionBloc(
        onboardingStatusStore: store,
        watchAuthState: watchAuthState,
        minimumSplashDuration: Duration.zero,
      );
    },
    act: (SessionBloc bloc) => bloc.add(const SessionStarted()),
    expect:
        () => const <SessionState>[
          SessionState(
            status: SessionStatus.unknown,
            onboardingCompleted: true,
          ),
        ],
  );

  blocTest<SessionBloc, SessionState>(
    'auth stream emitting null resolves to unauthenticated',
    build:
        () => SessionBloc(
          onboardingStatusStore: store,
          watchAuthState: watchAuthState,
          minimumSplashDuration: Duration.zero,
        ),
    seed:
        () => const SessionState(
          status: SessionStatus.unknown,
          onboardingCompleted: true,
        ),
    act: (SessionBloc bloc) async {
      authController.add(null);
      await Future<void>.delayed(Duration.zero);
    },
    wait: const Duration(milliseconds: 10),
    expect:
        () => const <SessionState>[
          SessionState(
            status: SessionStatus.unauthenticated,
            onboardingCompleted: true,
          ),
        ],
  );

  blocTest<SessionBloc, SessionState>(
    'auth stream emitting a user resolves to authenticated',
    build:
        () => SessionBloc(
          onboardingStatusStore: store,
          watchAuthState: watchAuthState,
          minimumSplashDuration: Duration.zero,
        ),
    seed:
        () => const SessionState(
          status: SessionStatus.unknown,
          onboardingCompleted: true,
        ),
    act: (SessionBloc bloc) async {
      authController.add(user);
      await Future<void>.delayed(Duration.zero);
    },
    wait: const Duration(milliseconds: 10),
    expect:
        () => const <SessionState>[
          SessionState(
            status: SessionStatus.authenticated,
            onboardingCompleted: true,
          ),
        ],
  );

  blocTest<SessionBloc, SessionState>(
    'SessionOnboardingCompleted re-reads the store flag',
    build: () {
      completed = false;
      return SessionBloc(
        onboardingStatusStore: store,
        watchAuthState: watchAuthState,
        minimumSplashDuration: Duration.zero,
      );
    },
    act: (SessionBloc bloc) async {
      bloc.add(const SessionStarted());
      await Future<void>.delayed(Duration.zero);
      // Simulates the onboarding bloc having written the flag.
      completed = true;
      bloc.add(const SessionOnboardingCompleted());
      await Future<void>.delayed(Duration.zero);
    },
    skip: 1,
    expect:
        () => const <SessionState>[
          SessionState(
            status: SessionStatus.unknown,
            onboardingCompleted: true,
          ),
        ],
  );

  group('AuthErrorMapper', () {
    test('maps known Firebase codes to Arabic auth failures', () {
      final AuthFailure unknownCode = AuthErrorMapper.mapCode(
        'email-already-in-use',
      );
      expect(unknownCode.message, 'هذا البريد الإلكتروني مسجّل بالفعل');
      expect(unknownCode.code, 'email-already-in-use');
      expect(unknownCode.type, FailureType.auth);
    });

    test('maps null and unrecognized codes to the generic message', () {
      expect(
        AuthErrorMapper.mapCode(null).message,
        'حدث خطأ غير متوقع، حاول مرة أخرى',
      );
      expect(
        AuthErrorMapper.mapCode('weird').message,
        'حدث خطأ غير متوقع، حاول مرة أخرى',
      );
    });
  });
}
