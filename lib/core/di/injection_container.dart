import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/datasources/firebase_auth_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/send_password_reset.dart';
import '../../features/auth/domain/usecases/sign_in_with_email.dart';
import '../../features/auth/domain/usecases/sign_up_with_email.dart';
import '../../features/auth/domain/usecases/watch_auth_state.dart';
import '../../features/auth/presentation/bloc/forgot_password/forgot_password_bloc.dart';
import '../../features/auth/presentation/bloc/login/login_bloc.dart';
import '../../features/auth/presentation/bloc/register/register_bloc.dart';
import '../../features/onboarding/presentation/bloc/onboarding_bloc.dart';
import '../routing/app_router.dart';
import '../session/session_bloc.dart';
import '../storage/onboarding_status_store.dart';

final GetIt getIt = GetIt.instance;

/// Registers every dependency for Phase 1.
///
/// Conventions: SharedPreferences/FirebaseAuth/repos/use cases = lazySingleton,
/// SessionBloc and AppRouter = singleton, feature BLoCs = factory.
Future<void> initDependencies() async {
  // Core.
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => preferences);
  getIt.registerLazySingleton<OnboardingStatusStore>(
    () => OnboardingStatusStore(getIt<SharedPreferences>()),
  );

  // Firebase.
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSource(getIt<FirebaseAuth>()),
  );

  // Auth data -> domain.
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<FirebaseAuthDataSource>()),
  );
  getIt.registerLazySingleton<SignInWithEmail>(
    () => SignInWithEmail(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<SignUpWithEmail>(
    () => SignUpWithEmail(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<SendPasswordReset>(
    () => SendPasswordReset(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<WatchAuthState>(
    () => WatchAuthState(getIt<AuthRepository>()),
  );

  // App-wide singletons.
  getIt.registerLazySingleton<SessionBloc>(
    () => SessionBloc(
      onboardingStatusStore: getIt<OnboardingStatusStore>(),
      watchAuthState: getIt<WatchAuthState>(),
    ),
  );
  getIt.registerLazySingleton<AppRouter>(
    () => AppRouter(sessionBloc: getIt<SessionBloc>()),
  );

  // Feature BLoCs (one instance per screen).
  getIt.registerFactory<OnboardingBloc>(
    () => OnboardingBloc(onboardingStatusStore: getIt<OnboardingStatusStore>()),
  );
  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(signInWithEmail: getIt<SignInWithEmail>()),
  );
  getIt.registerFactory<RegisterBloc>(
    () => RegisterBloc(signUpWithEmail: getIt<SignUpWithEmail>()),
  );
  getIt.registerFactory<ForgotPasswordBloc>(
    () => ForgotPasswordBloc(sendPasswordReset: getIt<SendPasswordReset>()),
  );
}
