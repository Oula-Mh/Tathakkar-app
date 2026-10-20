import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tathakkar/core/storage/onboarding_status_store.dart';
import 'package:tathakkar/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:tathakkar/features/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:tathakkar/features/onboarding/presentation/bloc/onboarding_state.dart';

class MockOnboardingStatusStore extends Mock implements OnboardingStatusStore {}

void main() {
  late MockOnboardingStatusStore store;
  late bool completed;

  setUp(() {
    completed = false;
    store = MockOnboardingStatusStore();
    when(() => store.isCompleted).thenAnswer((_) => completed);
    when(() => store.markCompleted()).thenAnswer((_) async {
      completed = true;
    });
  });

  OnboardingBloc buildBloc() => OnboardingBloc(onboardingStatusStore: store);

  blocTest<OnboardingBloc, OnboardingState>(
    'Skipped writes the completion flag exactly once and completes',
    build: buildBloc,
    seed:
        () => const OnboardingState(
          currentPage: 0,
          isCompleted: false,
          isSubmitting: false,
        ),
    act: (OnboardingBloc bloc) => bloc.add(const OnboardingSkipped()),
    expect:
        () => <dynamic>[
          const OnboardingState(
            currentPage: 0,
            isCompleted: false,
            isSubmitting: true,
          ),
          const OnboardingState(
            currentPage: 0,
            isCompleted: true,
            isSubmitting: false,
          ),
        ],
    verify: (_) {
      verify(() => store.markCompleted()).called(1);
    },
  );

  blocTest<OnboardingBloc, OnboardingState>(
    'Finished writes the completion flag and completes',
    build: buildBloc,
    act: (OnboardingBloc bloc) => bloc.add(const OnboardingFinished()),
    expect:
        () => <dynamic>[
          const OnboardingState(
            currentPage: 0,
            isCompleted: false,
            isSubmitting: true,
          ),
          const OnboardingState(
            currentPage: 0,
            isCompleted: true,
            isSubmitting: false,
          ),
        ],
    verify: (_) {
      verify(() => store.markCompleted()).called(1);
    },
  );

  blocTest<OnboardingBloc, OnboardingState>(
    'page changes only move the current page',
    build: buildBloc,
    seed:
        () => const OnboardingState(
          currentPage: 0,
          isCompleted: false,
          isSubmitting: false,
        ),
    act: (OnboardingBloc bloc) => bloc.add(const OnboardingPageChanged(2)),
    expect:
        () => <dynamic>[
          const OnboardingState(
            currentPage: 2,
            isCompleted: false,
            isSubmitting: false,
          ),
        ],
    verify: (_) {
      verifyNever(() => store.markCompleted());
    },
  );

  blocTest<OnboardingBloc, OnboardingState>(
    'completion events are ignored once already completed',
    build: buildBloc,
    seed:
        () => const OnboardingState(
          currentPage: 2,
          isCompleted: true,
          isSubmitting: false,
        ),
    act: (OnboardingBloc bloc) => bloc.add(const OnboardingFinished()),
    expect: () => <dynamic>[],
    verify: (_) {
      verifyNever(() => store.markCompleted());
    },
  );
}
