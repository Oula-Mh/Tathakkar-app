# Phase 1 Implementation Status

This file records actual implementation progress only. It does not change approved requirements.
Authoritative sources: `AGENTS.md`, `PHASE_1_APPROVED_PLAN.md`, `PROMPT_PHASE_1_PLAN.md`, `new_promt.md`, `ui_phase_1/`.

## Current Phase and Step

- Phase: Phase 1.
- Step: Step 4–7 complete; UI correction pass against `ui_phase_1/*.jpg` complete; follow-up corrections from `new_promt.md` (§1–§3), bug-fix pass (§2–§5), and the startup/navigation pass (startup states + auth route replacement) complete. Awaiting owner verification on a device/emulator.

## Completed Work

- Read all planning and rule docs; inspected project state (stock counter app only).
- Confirmed tooling: Flutter 3.29.3 / Dart 3.7.2; `firebase` CLI 15.32.1 authenticated.
- Created `PHASE_1_APPROVED_PLAN.md` and this status file.
- Added dependencies (flutter_bloc, equatable, go_router, shared_preferences, smooth_page_indicator, formz, dartz, connectivity_plus, get_it, firebase_core, firebase_auth, flutter_localizations; dev bloc_test, mocktail, fake_async).
- Downloaded Cairo variable TTF + OFL license to `assets/fonts/`; registered the `Cairo` family in `pubspec.yaml`.
- Firebase connected to existing project `tathakkar-4d181` via FlutterFire: registered android/ios apps, generated `lib/firebase_options.dart`, wrote `android/app/google-services.json`, applied Google-services Gradle plugin.
- Platform config: Android `minSdk = 23`; iOS deployment target 12.0 → 13.0.
- Core foundation: design tokens (`app_colors`, `app_spacing`, `app_radius`, `app_typography`), `app_theme`, centralized Arabic strings (`app_strings`), pure value validators, error model + `AuthErrorMapper`, responsive layout, shared widgets (`app_background`, `glass_card`, `primary_button`, `app_text_form_field`, `password_field`, `app_message`, `app_loading_indicator`, `capsule_icon`, `circle_back_button`, `splash_page`).
- DI: `lib/core/di/injection_container.dart` (get_it; SharedPreferences/FirebaseAuth/repos/use cases lazySingleton, SessionBloc/AppRouter singleton, feature BLoCs factory).
- Session + routing: `OnboardingStatusStore`, `SessionBloc`/events/state, `AppRouter` with the single redirect priority rule, `GoRouterRefreshStream`, `AppRoutes`, `SplashPage`.
- Onboarding (presentation-only): bloc + events/state, `OnboardingPage` (visual PageView, RTL pill indicator, skip/finish). Flag written only on explicit skip/finish.
- Auth domain: `AppUser`, `AuthRepository` contract (dartz `Either<Failure,_>`), use cases (`SignInWithEmail`, `SignUpWithEmail`, `SendPasswordReset`, `WatchAuthState`).
- Auth data: `FirebaseAuthDataSource` + `AuthRepositoryImpl` (maps `FirebaseAuthException` codes via `AuthErrorMapper`).
- Auth presentation: formz inputs (`EmailInput`, `PasswordInput`, `ConfirmPasswordInput`, `NameInput`), `LoginBloc/RegisterBloc/ForgotPasswordBloc`, pages `LoginPage`, `RegisterPage`, `ForgotPasswordPage`.
- Home: `HomePlaceholderPage`.
- Entry: `lib/app.dart` (SessionBloc provider, `MaterialApp.router`, Arabic locale + RTL delegates) and rewritten `lib/main.dart` (Firebase init, `initDependencies`, `runApp`).

### UI correction pass (against `ui_phase_1/*.jpg`)

- Tokens corrected from sampled reference colors/geometry: header gradient `#4E8AA0 → #6FA6BF`, primary `#41819C`, primary light/dark button gradient, light-blue background with soft white blobs, bluish card gradient, dark text `#193D53`, muted text, pale blue info surfaces, success/error colors; radius tokens (input 24, card 36, panel 44).
- Auth: rebuilt `AuthHeader` as the teal gradient panel with rounded bottom, white title/supporting line, outlined continue circle (top-right) and optional filled back chip (register, top-left); new shared `AuthScaffold` (header + overlapping card) and `AuthFormCard`; inputs now show the label above, a pill field, and an inline warning-icon error row; primary button is a gradient pill with shadow and inline loading; password fields use the outlined eye; copy updated to the reference wording.
- Forgot password: removed the separate resend control per `new_promt.md` §5; a single send button now carries the 60-second cooldown countdown and is disabled while the cooldown runs (cooldown still starts only after a successful request).
- Register: reference layout (no login footer), terms checkbox restored and wired to `RegisterTermsChanged` (the approved plan and existing tests require terms acceptance).
- Onboarding: light translucent rounded panel with three composed illustrations (reminder card with chips, medication rows with confirmed/upcoming badges, family profile cards with check badge); skip at top-left; custom right-to-left indicator with an elongated active pill; title/body from the reference; gradient pill CTA.
- Splash: teal gradient with center glow, translucent rounded logo tile with two-tone capsule and check badge, large wordmark, letter-spaced tagline; loading spinner removed (not in the reference).

### Follow-up corrections (`new_promt.md` §1–§3)

- Onboarding: the custom indicator was replaced with `SmoothPageIndicator` (`ExpandingDotsEffect`, primary active pill 24×8, inactive 8×8, 8 spacing, RTL direction, dot taps animate the same `PageController`); existing visuals/copy/layout unchanged. `onboarding_indicator.dart` deleted.
- Auth header: the gradient now extends behind the status bar (header height + top inset) while all header content keeps its previous offset, removing the empty band above the panel.
- Auth scrolling: the page is no longer scrollable; the header stays fixed and only the form inside `AuthFormCard` scrolls (`ListView(shrinkWrap: true)`), including when the keyboard is open.
- Back navigation: login no longer renders the top-right back affordance (`showBackButton: false`); register (left chip + arrow) and forgot password (arrow) keep their working back buttons.
- Register: the terms/privacy checkbox, its event, state fields, copy, validation and submit guard were removed; registration now validates only name/email/password/confirm password.
- Splash: `SessionBloc` holds the first auth resolution for a minimum `minimumSplashDuration` (default 2500 ms) so the splash always appears for roughly 2–3 seconds; the splash UI is unchanged.

### Bug-fix pass (`new_promt.md` §2–§5)

- Startup root cause: `OnboardingStarted` surfaced the persisted completion flag as a live `isCompleted` transition, so the page forwarded `SessionOnboardingCompleted` and the router dismissed onboarding without user input. The event/handler are removed; completion is now reported only after an explicit Skip/Finish.
- Onboarding indicator: inactive dots are neutral gray (`dotInactive`), only the active pill uses `primary`; the row keeps a constant 24×8/8×8 footprint and fixed height, so the layout does not jump. `PageController` remains owned/disposed by the page.
- Register header: removed the register-only left back chip (`showBackChip` removed from `AuthHeader`/`AuthScaffold` and the page), leaving exactly one working back affordance (the shared top-right circle). Login keeps no back button; Forgot Password keeps its back button.
- Register footer: added the `هل لديك حساب؟` / `نعم` row directly below Create Account, styled like the login footer (`AppStrings.hasAccountPrompt`, `AppStrings.loginAction`), with `نعم` pushing the existing login route.

### Navigation pass (`new_promt.md`: startup states + auth route replacement)

- Startup states are evaluated by the existing single router redirect in a fixed order: unresolved auth → splash; onboarding incomplete → onboarding; then login/home. Onboarding completion (`onboarding_completed` in SharedPreferences) and authentication remain separate inputs; both Skip and Finish persist the flag and immediately hand over to the session.
- Auth page transitions now replace instead of push: Login → Register, Register → Login, and Login → Forgot Password use `pushReplacement`; the Register/Forgot header back control also replaces the current page with Login. The auth stack never contains more than one auth page.

### Startup-persistence re-audit (`new_promt.md`: onboarding persistence and session initialization)

- Re-traced the full lifecycle: `SharedPreferences` is loaded once in `initDependencies`; `OnboardingStatusStore` wraps the single `onboarding_completed` bool; `OnboardingBloc` writes it with `await` on Skip/Finish before reporting completion; `SessionBloc` re-reads the same store on `SessionStarted`/`SessionOnboardingCompleted`; `AppRouter` resolves unresolved auth to Splash, incomplete onboarding to Onboarding, then Login/Home.
- Conclusion: the previously removed `OnboardingStarted` forwarding path was the only route that dismissed onboarding from a stored flag; no remaining code path displays onboarding once the flag is `true`, and the router never treats an uninitialized session as a first-time user. No production-code change was required for this pass.

## Changed Files

- Created (planning): `PHASE_1_APPROVED_PLAN.md`, `IMPLEMENTATION_STATUS.md`.
- Created (Firebase): `lib/firebase_options.dart`, `android/app/google-services.json`, `firebase.json`, `assets/fonts/Cairo.ttf`, `assets/fonts/OFL.txt`.
- Modified: `pubspec.yaml` (deps, Cairo font family), `android/app/build.gradle.kts` (google-services plugin + minSdk 23), `android/settings.gradle.kts` (google-services plugin), `ios/Runner.xcodeproj/project.pbxproj` (deployment target 13.0), `lib/main.dart` (rewritten).
- Created (Dart, under `lib/`): `app.dart`; `core/{constants,di,error,responsive,routing,session,storage,theme,utils,widgets}`; `features/onboarding/presentation/{bloc,widgets,pages}`; `features/auth/{domain,data,presentation}`; `features/home/presentation/pages/home_placeholder_page.dart`.
- Created (tests): `test/core/session/session_bloc_test.dart`, `test/features/auth/login_bloc_test.dart`, `test/features/auth/register_bloc_test.dart`, `test/features/auth/forgot_password_bloc_test.dart`, `test/features/onboarding/onboarding_bloc_test.dart`.
- Deleted: `test/widget_test.dart` (stock counter test).
- UI correction pass created `features/auth/presentation/widgets/{auth_scaffold,auth_form_card}.dart`, `features/onboarding/presentation/widgets/onboarding_visuals.dart`, `core/widgets/capsule_icon.dart`; rewrote `auth_header`, auth pages, onboarding page/slide, splash, shared button/field/background, theme tokens and strings.
- Follow-up corrections modified `onboarding_page.dart`, `session_bloc.dart`, `auth_scaffold.dart`, `auth_header.dart`, `login_page.dart`, `register_page.dart`, `register_event.dart`, `register_state.dart`, `register_bloc.dart`, `app_strings.dart`, `test/core/session/session_bloc_test.dart`, `test/features/auth/register_bloc_test.dart`; deleted `features/onboarding/presentation/widgets/onboarding_indicator.dart`.
- Bug-fix pass modified `onboarding_bloc.dart`, `onboarding_event.dart`, `onboarding_page.dart`, `app_colors.dart` (gray inactive dot), `auth_header.dart`, `auth_scaffold.dart`, `register_page.dart`, `app_strings.dart`.
- Navigation pass modified `login_page.dart` and `register_page.dart` (auth links use `pushReplacement`) and `auth_header.dart` (back control replaces with Login).

## Work in Progress

- None. Step is code-complete and passing local checks.

## Remaining Work

1. Owner: enable Email/Password provider in the Firebase Console.
2. Owner: run on an emulator/device and visually compare against `ui_phase_1/*.jpg`.
3. Owner: confirm the run behaves per the approved flow (splash → onboarding → auth → home).

## Verification Results

- `flutter --version`: 3.29.3, Dart 3.7.2 (passed).
- `firebase projects:list` / `apps:list` (read-only): authenticated; `tathakkar-4d181` and registered apps present (passed).
- `flutter pub get`: resolved dependencies (passed).
- `dart format lib test` using the project SDK (`C:\src\flutter_3.29.3\bin\dart.bat`): applied, 0 changes on the final run (passed).
- `flutter analyze`: No issues found (passed).
- `flutter test`: 24 tests, All tests passed (passed).
- Temporary widget smoke tests of the new auth layout at 360×800 (header begins at the screen top and stays fixed across scrolling, card overlap/height geometry, short-form sizing, no overflow with a 320 px keyboard inset): 3/3 passed; file removed afterwards (passed).
- Temporary startup-flow widget test with the real `SessionBloc`/`AppRouter` (first-time user stays on onboarding for 3+ s; returning user reaches login after the splash): 2/2 passed; file removed afterwards (passed).
- Temporary navigation-flow widget test with the real router and mocked auth/use cases (fresh install → onboarding stays; Skip persists the flag and reaches login; simulated restart → login; authenticated restart → home; Login↔Register, Login↔Forgot replace each other with a single non-poppable auth page): 4/4 passed; file removed afterwards (passed).
- Temporary five-scenario persistence test against the real router/session/store (Finish → login → restart → login; Skip → login → restart → login; authenticated → home → restart → home; completed + signed out → login → restart → login; incomplete → restart → onboarding): 5/5 passed; file removed afterwards (passed).
- Device/emulator run and pixel-level UI comparison: not run by the executing model (owner action required).

## Known Issues and Blockers

- iOS `GoogleService-Info.plist` cannot be downloaded via CLI (HTTP 400) and FlutterFire cannot add it to the Xcode project from Windows. The app uses `lib/firebase_options.dart`, so Android/iOS runtime auth is unaffected.
- `firebase apps:list` shows extra duplicate android/ios/web apps created by an earlier configure run; only `android:069aeb4a65d39580bb15b8` and `ios:e11b4677282f0d99bb15b8` are referenced. Harmless; not deleted (destructive, out of scope).
- Firebase Email/Password provider enablement is a manual owner action in the Firebase Console (not yet done).
- `register.jpg` "2/59" badge meaning unknown → intentionally not rendered (approved decision).
- The outlined circle arrow (top-right) on Register/Forgot now navigates to Login with `pushReplacement` (consistent with the auth-route replacement requirement). Because the auth stack keeps one page, Android system Back on an auth page exits the app instead of returning to a previous auth page.
- Reference illustrations are composed from design tokens and icons because no raster illustration assets were supplied; minor differences from the rendered artwork are expected.
- The `dart` on PATH is 3.0.1; always use the Flutter SDK's Dart 3.7.2 for formatting/analysis to keep the project consistent.
- The auth header gradient now extends behind the status bar; status-bar icon brightness is left to platform/Material defaults (no `SystemChrome` override) and was not verified on a device.
- Onboarding indicator taps are handled by `smooth_page_indicator` (8 px tall dot row); the previous custom widget had a larger tap padding. The dot row is a secondary affordance; the Next/Finish button remains the primary navigation.
- The reported automatic onboarding dismissal could only be reproduced through the removed stored-flag forwarding path; a first-time flow test keeps onboarding on screen indefinitely and a returning-user flow still reaches login. If the device still shows a dismissal, the persisted `onboarding_completed` flag (written only on Skip/Finish) is the remaining variable to check.
- Owner confirmation needed: the latest five-scenario audit passes against the current source, so a device that still shows onboarding after Skip/Finish is most likely running an older install or has lost its app data. Please confirm the tested build and app-data state before any further code change.
- The inactive dot color is now a neutral gray value on the existing `dotInactive` token (required by `new_promt.md` §3C); the reference dots were pale blue-gray.
- Project is not a git repository.

## Next Action

Owner verification: enable the Email/Password provider in the Firebase Console, then run the app on an emulator/device and compare the splash, onboarding, and auth screens against `ui_phase_1/*.jpg`. Report any visual differences for correction.
