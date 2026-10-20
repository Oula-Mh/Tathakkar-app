import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/constants/app_strings.dart';
import 'core/di/injection_container.dart';
import 'core/routing/app_router.dart';
import 'core/session/session_bloc.dart';
import 'core/session/session_event.dart';
import 'core/theme/app_theme.dart';

/// Root widget: provides the app-wide [SessionBloc], wires the GoRouter, and
/// configures the Arabic RTL localization.
class TathakkarApp extends StatelessWidget {
  const TathakkarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SessionBloc>(
      create: (_) => getIt<SessionBloc>()..add(SessionStarted()),
      child: Builder(
        builder: (BuildContext context) {
          final AppRouter appRouter = getIt<AppRouter>();
          return MaterialApp.router(
            title: AppStrings.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            locale: const Locale('ar'),
            supportedLocales: const <Locale>[Locale('ar')],
            localizationsDelegates: const <LocalizationsDelegate<Object?>>[
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: appRouter.router,
          );
        },
      ),
    );
  }
}
