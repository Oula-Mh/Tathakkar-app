import 'package:shared_preferences/shared_preferences.dart';

/// Small encapsulated persistence service for the onboarding-completed flag.
///
/// Shared by the onboarding bloc (write) and the session bloc (read) so there
/// is a single source of truth. Writing the flag happens only when the user
/// explicitly skips or finishes onboarding.
class OnboardingStatusStore {
  OnboardingStatusStore(this._preferences);

  static const String completedKey = 'onboarding_completed';

  final SharedPreferences _preferences;

  /// True when the user has explicitly completed or skipped onboarding.
  bool get isCompleted => _preferences.getBool(completedKey) ?? false;

  /// Marks onboarding as completed. Called only on explicit skip/finish.
  Future<void> markCompleted() => _preferences.setBool(completedKey, true);
}
