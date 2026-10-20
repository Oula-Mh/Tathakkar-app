import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tathakkar/core/error/failure.dart';
import 'package:tathakkar/features/auth/domain/usecases/send_password_reset.dart';
import 'package:tathakkar/features/auth/presentation/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:tathakkar/features/auth/presentation/bloc/forgot_password/forgot_password_event.dart';
import 'package:tathakkar/features/auth/presentation/bloc/forgot_password/forgot_password_state.dart';
import 'package:tathakkar/features/auth/presentation/bloc/form_submission_status.dart';
import 'package:tathakkar/features/auth/presentation/form_inputs/email_input.dart';

class MockSendPasswordReset extends Mock implements SendPasswordReset {}

void main() {
  late MockSendPasswordReset sendPasswordReset;

  setUp(() {
    sendPasswordReset = MockSendPasswordReset();
  });

  ForgotPasswordBloc buildBloc() =>
      ForgotPasswordBloc(sendPasswordReset: sendPasswordReset);

  void stubReset(Future<Either<Failure, Unit>> result) {
    when(
      () => sendPasswordReset(email: any(named: 'email')),
    ).thenAnswer((_) => result);
  }

  blocTest<ForgotPasswordBloc, ForgotPasswordState>(
    'invalid email shows validation errors and never calls the use case',
    build: buildBloc,
    act: (ForgotPasswordBloc bloc) => bloc.add(const ForgotSubmitted()),
    expect:
        () => <dynamic>[
          const ForgotPasswordState(
            email: EmailInput.dirty(''),
            status: FormSubmissionStatus.initial,
            showErrorMessages: true,
            countdownSeconds: 0,
            resetEmailSent: false,
          ),
        ],
    verify: (_) {
      verifyNever(() => sendPasswordReset(email: any(named: 'email')));
    },
  );

  blocTest<ForgotPasswordBloc, ForgotPasswordState>(
    'success starts the resend countdown at 60 seconds',
    build: () {
      stubReset(Future<Either<Failure, Unit>>.value(const Right(unit)));
      return buildBloc();
    },
    act: (ForgotPasswordBloc bloc) async {
      bloc.add(const ForgotEmailChanged('user@example.com'));
      await Future<void>.delayed(Duration.zero);
      bloc.add(const ForgotSubmitted());
      await Future<void>.delayed(Duration.zero);
    },
    expect:
        () => <dynamic>[
          const ForgotPasswordState(
            email: EmailInput.dirty('user@example.com'),
            status: FormSubmissionStatus.initial,
            showErrorMessages: false,
            countdownSeconds: 0,
            resetEmailSent: false,
          ),
          const ForgotPasswordState(
            email: EmailInput.dirty('user@example.com'),
            status: FormSubmissionStatus.submitting,
            showErrorMessages: true,
            countdownSeconds: 0,
            resetEmailSent: false,
          ),
          isA<ForgotPasswordState>()
              .having(
                (ForgotPasswordState s) => s.status,
                'status',
                FormSubmissionStatus.success,
              )
              .having(
                (ForgotPasswordState s) => s.countdownSeconds,
                'countdown',
                ForgotPasswordBloc.countdownDurationSeconds,
              )
              .having(
                (ForgotPasswordState s) => s.resetEmailSent,
                'sent',
                isTrue,
              ),
        ],
    verify: (ForgotPasswordBloc bloc) {
      expect(bloc.state.resendEnabled, isFalse);
    },
  );

  blocTest<ForgotPasswordBloc, ForgotPasswordState>(
    'failure does not start or reset the countdown',
    build: () {
      stubReset(
        Future<Either<Failure, Unit>>.value(
          Left(const NetworkFailure('تعذر الاتصال')),
        ),
      );
      return buildBloc();
    },
    act: (ForgotPasswordBloc bloc) async {
      bloc.add(const ForgotEmailChanged('user@example.com'));
      await Future<void>.delayed(Duration.zero);
      bloc.add(const ForgotSubmitted());
      await Future<void>.delayed(Duration.zero);
    },
    expect:
        () => <dynamic>[
          const ForgotPasswordState(
            email: EmailInput.dirty('user@example.com'),
            status: FormSubmissionStatus.initial,
            showErrorMessages: false,
            countdownSeconds: 0,
            resetEmailSent: false,
          ),
          const ForgotPasswordState(
            email: EmailInput.dirty('user@example.com'),
            status: FormSubmissionStatus.submitting,
            showErrorMessages: true,
            countdownSeconds: 0,
            resetEmailSent: false,
          ),
          const ForgotPasswordState(
            email: EmailInput.dirty('user@example.com'),
            status: FormSubmissionStatus.failure,
            showErrorMessages: true,
            countdownSeconds: 0,
            resetEmailSent: false,
            errorMessage: 'تعذر الاتصال',
          ),
        ],
  );

  test('countdown ticks down each second and re-enables resend at zero', () {
    fakeAsync((FakeAsync async) {
      stubReset(Future<Either<Failure, Unit>>.value(const Right(unit)));

      final ForgotPasswordBloc bloc = buildBloc();
      addTearDown(bloc.close);

      bloc.add(const ForgotEmailChanged('user@example.com'));
      async.flushMicrotasks();
      bloc.add(const ForgotSubmitted());
      async.flushMicrotasks();

      expect(
        bloc.state.countdownSeconds,
        ForgotPasswordBloc.countdownDurationSeconds,
      );
      expect(bloc.state.resendEnabled, isFalse);

      async.elapse(const Duration(seconds: 3));
      async.flushMicrotasks();
      expect(
        bloc.state.countdownSeconds,
        ForgotPasswordBloc.countdownDurationSeconds - 3,
      );

      async.elapse(const Duration(seconds: 30));
      async.flushMicrotasks();
      expect(bloc.state.resendEnabled, isFalse);

      async.elapse(const Duration(seconds: 27));
      async.flushMicrotasks();
      expect(bloc.state.countdownSeconds, 0);
      expect(bloc.state.resendEnabled, isTrue);
    });
  });
}
