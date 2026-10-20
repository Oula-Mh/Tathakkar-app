import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/home/presentation/pages/home_placeholder_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../session/session_bloc.dart';
import '../session/session_state.dart';
import '../widgets/splash_page.dart';
import 'app_routes.dart';
import 'router_refresh.dart';

/// Application router: the single redirect authority for startup routing.
///
/// Priority:
/// 1. Unresolved state -> Splash (no wrong-screen flash).
/// 2. Onboarding not completed -> Onboarding.
/// 3. Completed + unauthenticated -> auth screens.
/// 4. Completed + authenticated -> Home.
class AppRouter {
  AppRouter({required SessionBloc sessionBloc})
    : router = GoRouter(
        initialLocation: AppRoutes.splash,
        refreshListenable: GoRouterRefreshStream(sessionBloc.stream),
        redirect:
            (BuildContext context, GoRouterState state) =>
                _redirect(sessionBloc.state, state.matchedLocation),
        routes: <RouteBase>[
          GoRoute(
            path: AppRoutes.splash,
            builder:
                (BuildContext context, GoRouterState state) =>
                    const SplashPage(),
          ),
          GoRoute(
            path: AppRoutes.onboarding,
            builder:
                (BuildContext context, GoRouterState state) =>
                    const OnboardingPage(),
          ),
          GoRoute(
            path: AppRoutes.login,
            builder:
                (BuildContext context, GoRouterState state) =>
                    const LoginPage(),
          ),
          GoRoute(
            path: AppRoutes.register,
            builder:
                (BuildContext context, GoRouterState state) =>
                    const RegisterPage(),
          ),
          GoRoute(
            path: AppRoutes.forgotPassword,
            builder:
                (BuildContext context, GoRouterState state) =>
                    const ForgotPasswordPage(),
          ),
          GoRoute(
            path: AppRoutes.home,
            builder:
                (BuildContext context, GoRouterState state) =>
                    const HomePlaceholderPage(),
          ),
        ],
      );

  final GoRouter router;

 static String? _redirect(SessionState session, String location) {


  if (session.status == SessionStatus.unknown) {
    return location == AppRoutes.splash
        ? null
        : AppRoutes.splash;
  }

  if (!session.onboardingCompleted) {
    return location == AppRoutes.onboarding
        ? null
        : AppRoutes.onboarding;
  }

  switch (session.status) {
    case SessionStatus.unauthenticated:
      final bool onAuthRoute =
          location == AppRoutes.login ||
          location == AppRoutes.register ||
          location == AppRoutes.forgotPassword;

      return onAuthRoute ? null : AppRoutes.login;

    case SessionStatus.authenticated:
      return location == AppRoutes.home
          ? null
          : AppRoutes.home;

    case SessionStatus.unknown:
      return AppRoutes.splash;
  }
}
}
