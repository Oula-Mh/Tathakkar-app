import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tathakkar/core/constants/app_strings.dart';
import 'package:tathakkar/core/error/failure.dart';
import 'package:tathakkar/features/auth/domain/entities/app_user.dart';
import 'package:tathakkar/features/auth/domain/usecases/sign_in_with_email.dart';
import 'package:tathakkar/features/auth/presentation/bloc/form_submission_status.dart';
import 'package:tathakkar/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:tathakkar/features/auth/presentation/bloc/login/login_event.dart';
import 'package:tathakkar/features/auth/presentation/bloc/login/login_state.dart';
import 'package:tathakkar/features/auth/presentation/form_inputs/email_input.dart';
import 'package:tathakkar/features/auth/presentation/form_inputs/password_input.dart';

class MockSignInWithEmail extends Mock implements SignInWithEmail {}

void main() {
  late MockSignInWithEmail signInWithEmail;

  const AppUser user = AppUser(uid: 'uid-1');

  setUpAll(() {
    registerFallbackValue(const AuthFailure('fallback'));
  });

  setUp(() {
    signInWithEmail = MockSignInWithEmail();
  });

  LoginBloc buildBloc() => LoginBloc(signInWithEmail: signInWithEmail);

  void stubSignIn(Future<Either<Failure, AppUser>> result) {
    when(
      () => signInWithEmail(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) => result);
  }

  blocTest<LoginBloc, LoginState>(
    'emits error flags without calling the use case when inputs are invalid',
    build: buildBloc,
    seed: () => const LoginState.initial(),
    act: (LoginBloc bloc) => bloc.add(const LoginSubmitted()),
    expect:
        () => <dynamic>[
          const LoginState(
            email: EmailInput.dirty(''),
            password: PasswordInput.dirty(''),
            status: FormSubmissionStatus.initial,
            showErrorMessages: true,
          ),
        ],
    verify: (_) {
      verifyNever(
        () => signInWithEmail(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      );
    },
  );

  blocTest<LoginBloc, LoginState>(
    'submitting valid credentials emits submitting then success',
    build: () {
      stubSignIn(Future<Either<Failure, AppUser>>.value(Right(user)));
      return buildBloc();
    },
    seed:
        () => const LoginState(
          email: EmailInput.dirty('user@example.com'),
          password: PasswordInput.dirty('secret1'),
          status: FormSubmissionStatus.initial,
          showErrorMessages: false,
        ),
    act: (LoginBloc bloc) => bloc.add(const LoginSubmitted()),
    expect:
        () => <LoginState>[
          const LoginState(
            email: EmailInput.dirty('user@example.com'),
            password: PasswordInput.dirty('secret1'),
            status: FormSubmissionStatus.submitting,
            showErrorMessages: true,
          ),
          const LoginState(
            email: EmailInput.dirty('user@example.com'),
            password: PasswordInput.dirty('secret1'),
            status: FormSubmissionStatus.success,
            showErrorMessages: true,
          ),
        ],
  );

  blocTest<LoginBloc, LoginState>(
    'submitting valid credentials emits submitting then failure with message',
    build: () {
      stubSignIn(
        Future<Either<Failure, AppUser>>.value(
          Left(const AuthFailure('خطأ ما', code: 'x')),
        ),
      );
      return buildBloc();
    },
    seed:
        () => const LoginState(
          email: EmailInput.dirty('user@example.com'),
          password: PasswordInput.dirty('secret1'),
          status: FormSubmissionStatus.initial,
          showErrorMessages: false,
        ),
    act: (LoginBloc bloc) => bloc.add(const LoginSubmitted()),
    expect:
        () => <LoginState>[
          const LoginState(
            email: EmailInput.dirty('user@example.com'),
            password: PasswordInput.dirty('secret1'),
            status: FormSubmissionStatus.submitting,
            showErrorMessages: true,
          ),
          const LoginState(
            email: EmailInput.dirty('user@example.com'),
            password: PasswordInput.dirty('secret1'),
            status: FormSubmissionStatus.failure,
            showErrorMessages: true,
            errorMessage: 'خطأ ما',
          ),
        ],
  );

  blocTest<LoginBloc, LoginState>(
    'changing the email clears a previous failure message',
    build: buildBloc,
    seed:
        () => const LoginState(
          email: EmailInput.dirty('old@example.com'),
          password: PasswordInput.dirty('secret1'),
          status: FormSubmissionStatus.failure,
          showErrorMessages: true,
          errorMessage: AppStrings.authUnknown,
        ),
    act:
        (LoginBloc bloc) =>
            bloc.add(const LoginEmailChanged('new@example.com')),
    expect:
        () => <LoginState>[
          const LoginState(
            email: EmailInput.dirty('new@example.com'),
            password: PasswordInput.dirty('secret1'),
            status: FormSubmissionStatus.initial,
            showErrorMessages: true,
          ),
        ],
  );

  blocTest<LoginBloc, LoginState>(
    'ignores duplicate submissions while one is in progress',
    build: () {
      stubSignIn(Future<Either<Failure, AppUser>>.value(Right(user)));
      return buildBloc();
    },
    seed:
        () => const LoginState(
          email: EmailInput.dirty('user@example.com'),
          password: PasswordInput.dirty('secret1'),
          status: FormSubmissionStatus.submitting,
          showErrorMessages: true,
        ),
    act: (LoginBloc bloc) => bloc.add(const LoginSubmitted()),
    expect: () => <LoginState>[],
    verify: (_) {
      verifyNever(
        () => signInWithEmail(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      );
    },
  );
}
