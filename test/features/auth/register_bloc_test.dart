import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tathakkar/core/error/failure.dart';
import 'package:tathakkar/features/auth/domain/entities/app_user.dart';
import 'package:tathakkar/features/auth/domain/usecases/sign_up_with_email.dart';
import 'package:tathakkar/features/auth/presentation/bloc/form_submission_status.dart';
import 'package:tathakkar/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:tathakkar/features/auth/presentation/bloc/register/register_event.dart';
import 'package:tathakkar/features/auth/presentation/bloc/register/register_state.dart';
import 'package:tathakkar/features/auth/presentation/form_inputs/confirm_password_input.dart';
import 'package:tathakkar/features/auth/presentation/form_inputs/email_input.dart';
import 'package:tathakkar/features/auth/presentation/form_inputs/name_input.dart';
import 'package:tathakkar/features/auth/presentation/form_inputs/password_input.dart';

class MockSignUpWithEmail extends Mock implements SignUpWithEmail {}

void main() {
  late MockSignUpWithEmail signUpWithEmail;

  const AppUser user = AppUser(uid: 'uid-1');

  setUp(() {
    signUpWithEmail = MockSignUpWithEmail();
  });

  RegisterBloc buildBloc() => RegisterBloc(signUpWithEmail: signUpWithEmail);

  void stubSignUp(Future<Either<Failure, AppUser>> result) {
    when(
      () => signUpWithEmail(
        name: any(named: 'name'),
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) => result);
  }

  blocTest<RegisterBloc, RegisterState>(
    'revalidates the confirmation immediately when the password changes',
    build: buildBloc,
    seed:
        () => const RegisterState(
          name: NameInput.dirty('أحمد'),
          email: EmailInput.dirty('user@example.com'),
          password: PasswordInput.dirty('123456'),
          confirmPassword: ConfirmPasswordInput.dirty(
            'different',
            password: '123456',
          ),
          status: FormSubmissionStatus.initial,
          showErrorMessages: false,
        ),
    act:
        (RegisterBloc bloc) =>
            bloc.add(const RegisterPasswordChanged('654321')),
    expect:
        () => <RegisterState>[
          const RegisterState(
            name: NameInput.dirty('أحمد'),
            email: EmailInput.dirty('user@example.com'),
            password: PasswordInput.dirty('654321'),
            confirmPassword: ConfirmPasswordInput.dirty(
              'different',
              password: '654321',
            ),
            status: FormSubmissionStatus.initial,
            showErrorMessages: false,
          ),
        ],
    verify: (RegisterBloc bloc) {
      expect(
        bloc.state.confirmPassword.error,
        ConfirmPasswordValidationError.mismatch,
      );
    },
  );

  blocTest<RegisterBloc, RegisterState>(
    'confirmation error clears when it now matches the password',
    build: buildBloc,
    seed:
        () => const RegisterState(
          name: NameInput.dirty('أحمد'),
          email: EmailInput.dirty('user@example.com'),
          password: PasswordInput.dirty('123456'),
          confirmPassword: ConfirmPasswordInput.dirty(
            'different',
            password: '123456',
          ),
          status: FormSubmissionStatus.initial,
          showErrorMessages: false,
        ),
    act:
        (RegisterBloc bloc) =>
            bloc.add(const RegisterConfirmPasswordChanged('123456')),
    verify: (RegisterBloc bloc) {
      expect(bloc.state.confirmPassword.error, isNull);
      expect(bloc.state.confirmPassword.isValid, isTrue);
    },
  );

  blocTest<RegisterBloc, RegisterState>(
    'submits valid registration and emits success',
    build: () {
      stubSignUp(Future<Either<Failure, AppUser>>.value(Right(user)));
      return buildBloc();
    },
    seed:
        () => const RegisterState(
          name: NameInput.dirty('أحمد'),
          email: EmailInput.dirty('user@example.com'),
          password: PasswordInput.dirty('123456'),
          confirmPassword: ConfirmPasswordInput.dirty(
            '123456',
            password: '123456',
          ),
          status: FormSubmissionStatus.initial,
          showErrorMessages: false,
        ),
    act: (RegisterBloc bloc) => bloc.add(const RegisterSubmitted()),
    expect:
        () => <dynamic>[
          isA<RegisterState>()
              .having(
                (RegisterState s) => s.status,
                'status',
                FormSubmissionStatus.submitting,
              )
              .having((RegisterState s) => s.showErrorMessages, 'errors', true),
          isA<RegisterState>()
              .having(
                (RegisterState s) => s.status,
                'status',
                FormSubmissionStatus.success,
              )
              .having((RegisterState s) => s.showErrorMessages, 'errors', true),
        ],
  );

  blocTest<RegisterBloc, RegisterState>(
    'shows validation errors and does not call the use case for invalid fields',
    build: buildBloc,
    seed:
        () => const RegisterState(
          name: NameInput.dirty('أحمد'),
          email: EmailInput.dirty('not-an-email'),
          password: PasswordInput.dirty('123456'),
          confirmPassword: ConfirmPasswordInput.dirty(
            '123456',
            password: '123456',
          ),
          status: FormSubmissionStatus.initial,
          showErrorMessages: false,
        ),
    act: (RegisterBloc bloc) => bloc.add(const RegisterSubmitted()),
    verify: (RegisterBloc bloc) {
      expect(bloc.state.showErrorMessages, isTrue);
      expect(bloc.state.status, FormSubmissionStatus.initial);
      verifyNever(
        () => signUpWithEmail(
          name: any(named: 'name'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      );
    },
  );
}
