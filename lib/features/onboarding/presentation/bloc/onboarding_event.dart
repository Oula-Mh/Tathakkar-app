import 'package:equatable/equatable.dart';

sealed class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// The user swiped/tapped to another page.
final class OnboardingPageChanged extends OnboardingEvent {
  const OnboardingPageChanged(this.pageIndex);

  final int pageIndex;

  @override
  List<Object?> get props => <Object?>[pageIndex];
}

/// The user tapped the primary action on a non-final page.
final class OnboardingNextPressed extends OnboardingEvent {
  const OnboardingNextPressed();
}

/// The user tapped Skip.
final class OnboardingSkipped extends OnboardingEvent {
  const OnboardingSkipped();
}

/// The user tapped the finish action on the last page.
final class OnboardingFinished extends OnboardingEvent {
  const OnboardingFinished();
}
