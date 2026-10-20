ال# Tathakkar — Phase 1 Approved Implementation Plan

Status: Approved (consolidated).
Sources: `AGENTS.md`, `PROMPT_PHASE_1_PLAN.md`, `ui_phase_1/` references, and explicit owner decisions made during planning.
This file preserves the approved decisions. It does not override `AGENTS.md`, which remains authoritative for engineering rules.

## 1. Purpose and Phase 1 Scope

Implement Phase 1 only:

- Core application foundation and design system.
- Responsive layout foundation and shared reusable widgets.
- Arabic localization and RTL support.
- Cairo font integration.
- Application routing with GoRouter.
- Onboarding (3 slides) with completion persistence.
- Login, Registration, and Forgot/Reset password with Firebase Authentication.
- Form validation (formz), BLoC state management, and consistent error mapping.
- Session-state management and startup routing.
- Integration with the next destination (Home placeholder) without unrelated features.

Out of scope: full Home feature, medication records, reminders, dose history, stock, family profiles, QR linking, notifications, and any other module not requested for Phase 1.

## 2. Current Project State (verified at start)

- Flutter 3.29.3 stable, Dart 3.7.2 (`environment: sdk: ^3.7.2`).
- Local project exists but has no application features: only stock `lib/main.dart` (counter demo) and stock `test/widget_test.dart`.
- Dependencies: only `cupertino_icons` and `flutter_lints`.
- Android `applicationId`/`namespace` = `com.example.tathakkar`.
- iOS bundle id = `com.example.tathakkar`; deployment target = 12.0.
- No local Firebase wiring: no `firebase_options.dart`, no `google-services.json`, no `GoogleService-Info.plist`, no Google-services Gradle plugin, no Firebase dependencies.
- Existing Firebase Console project `tathakkar` (project id `tathakkar-4d181`) exists and is **not connected** to this app. It must be reused; creating or replacing a Firebase project is not allowed.

## 3. Approved Decisions

1. Reuse the existing Firebase project `tathakkar` (`tathakkar-4d181`); never create a new project.
2. Use **get_it** for dependency injection, centralized in `lib/core/di/injection_container.dart`. This supersedes the earlier manual composition-root decision.
3. Feature-first structure under `lib/features/`; shared code under `lib/core/`.
4. Onboarding is presentation-focused: no `domain/` layer, no repository interface, no use cases. Persistence uses a small shared storage service in `core/`.
5. Onboarding is marked complete only when the user explicitly taps Skip or Finish — never on app open.
6. Arabic-first UI with RTL, Cairo font, centralized Arabic strings in `core/constants/app_strings.dart`.
7. BLoC is mandatory (Events/States/Bloc). Cubit is not used.
8. Firebase Authentication provides registration, login, password reset, and auth-state observation.
9. Session and routing decisions are centralized in a core `SessionBloc` and a single GoRouter redirect.
10. UI references in `ui_phase_1/` are authoritative for layout and visual design.
11. Documentation: only `PHASE_1_APPROVED_PLAN.md` and `IMPLEMENTATION_STATUS.md` are created. `PROMPT_PHASE_1_IMPLEMENTATION.md` is never created. `AGENTS.md`, `PROMPT_PHASE_1_PLAN.md`, and `ui_phase_1/` remain unchanged.

## 4. UI References and Design Tokens

References (all ~1080x2300, Arabic/RTL): `splash.jpg`, `onboarding_1.jpg`, `onboarding_2.jpg`, `onboarding_3.jpg`, `login.jpg`, `register.jpg`, `forget_password.jpg`, `home.jpg` (Home out of scope).

Approved tokens (centralized in `core/theme/`; no hardcoded duplicates in widgets):

- Primary steel teal: `#4A7C8C` (darker gradient `#3E6E7E`).
- Splash gradient: `#4E8595` to `#5C93A3`.
- Background: light blue `#E9F0F5` with soft blurred blobs.
- Surface: white glass-like cards, large radius, soft shadow.
- Text: dark `#1E3A44`; muted `#5B7480`.
- Success: background `#E4F0E7`, foreground `#2E7D4F`. Error: `#B3261E`.
- Inputs: white, 1px light border `#DCE4EA`, radius 18, height 56.
- Buttons: full pill, height 56, white label, primary fill.
- Typography: Cairo; titles 28–32 bold, body 15–16, buttons ~18.
- Spacing scale: 4, 8, 12, 16, 20, 24, 32, 40.
- Radii: inputs 18, cards 32, buttons pill.

Note: these tokens are the approved values. Pixel-level comparison against the JPG references must be confirmed by the project owner, because the executing AI model cannot open image files.

## 5. Dependencies

Reuse: `cupertino_icons`, `flutter_lints`, `flutter_test`.

Add: `flutter_bloc`, `equatable`, `go_router`, `shared_preferences`, `smooth_page_indicator`, `formz`, `dartz`, `connectivity_plus`, `firebase_core`, `firebase_auth`, `get_it`, `flutter_localizations` (SDK).

Dev: `bloc_test`, `mocktail`.

Exact versions resolved against Flutter 3.29.3 / Dart 3.7.2 during `flutter pub get`.
No `google_fonts` (Cairo TTFs are bundled). No `flutter_screenutil` (native responsiveness).

## 6. Project Structure

```
lib/
  main.dart
  app.dart
  firebase_options.dart                # generated by FlutterFire
  core/
    di/injection_container.dart
    storage/onboarding_status_store.dart
    constants/app_strings.dart
    constants/app_assets.dart
    theme/app_colors.dart
    theme/app_typography.dart
    theme/app_spacing.dart
    theme/app_radius.dart
    theme/app_theme.dart
    routing/app_routes.dart
    routing/app_router.dart
    routing/router_refresh.dart
    session/session_event.dart
    session/session_state.dart
    session/session_bloc.dart
    widgets/app_background.dart
    widgets/glass_card.dart
    widgets/primary_button.dart
    widgets/app_text_form_field.dart
    widgets/password_field.dart
    widgets/app_message.dart
    widgets/app_loading_indicator.dart
    error/failure.dart
    error/auth_error_mapper.dart
    utils/value_validators.dart
    responsive/responsive_layout.dart
  features/
    onboarding/
      presentation/bloc/onboarding_event.dart
      presentation/bloc/onboarding_state.dart
      presentation/bloc/onboarding_bloc.dart
      presentation/pages/onboarding_page.dart
      presentation/widgets/onboarding_slide.dart
      presentation/widgets/onboarding_indicator.dart
    auth/
      data/datasources/firebase_auth_data_source.dart
      data/repositories/auth_repository_impl.dart
      domain/entities/app_user.dart
      domain/repositories/auth_repository.dart
      domain/usecases/sign_in_with_email.dart
      domain/usecases/sign_up_with_email.dart
      domain/usecases/send_password_reset.dart
      domain/usecases/watch_auth_state.dart
      presentation/form_inputs/email_input.dart
      presentation/form_inputs/password_input.dart
      presentation/form_inputs/name_input.dart
      presentation/form_inputs/confirm_password_input.dart
      presentation/bloc/login/{login_event,login_state,login_bloc}.dart
      presentation/bloc/register/{register_event,register_state,register_bloc}.dart
      presentation/bloc/forgot_password/{forgot_password_event,forgot_password_state,forgot_password_bloc}.dart
      presentation/pages/{login_page,register_page,forgot_password_page}.dart
      presentation/widgets/{auth_header,auth_form_card,agreement_row}.dart
    home/
      presentation/pages/home_placeholder_page.dart
```

Onboarding has no `data/` or `domain/` folder.

## 7. Dependency Injection (get_it)

Single file: `lib/core/di/injection_container.dart`.

- `final GetIt getIt = GetIt.instance;`
- `Future<void> initDependencies()` registers everything in order: core, auth, session, blocs.

Lifetimes:

| Dependency | Lifetime |
|---|---|
| `SharedPreferences` | singleton (async, created in `initDependencies`) |
| `OnboardingStatusStore` | lazySingleton |
| `FirebaseAuth` | lazySingleton (`FirebaseAuth.instance`) |
| `FirebaseAuthDataSource` | lazySingleton |
| `AuthRepository` (impl) | lazySingleton |
| Auth use cases | lazySingleton |
| `SessionBloc` | singleton |
| `AppRouter` (GoRouter) | singleton |
| `OnboardingBloc` | factory |
| `LoginBloc` / `RegisterBloc` / `ForgotPasswordBloc` | factory |

Rules: `getIt` is used only at composition boundaries (main, router, BLoC providers). Domain/data classes receive dependencies via constructors. Per-screen BLoCs are disposed by `BlocProvider` (`close`), not by get_it. No overengineering or unnecessary registrations.

## 8. Firebase Connection (existing project `tathakkar`)

Local steps:

1. Add `firebase_core` and `firebase_auth`.
2. Activate a Dart-3.7.2-compatible FlutterFire CLI.
3. `flutterfire configure --project tathakkar-4d181` using the already-authenticated Firebase CLI (generates `lib/firebase_options.dart`, Android `google-services.json`, iOS `GoogleService-Info.plist`, registers Android/iOS apps if absent).
4. Android: apply the Google-services Gradle plugin; raise `minSdk` to >= 23 if required by Firebase.
5. iOS: raise deployment target to >= 13.0; ensure `GoogleService-Info.plist` is in the Runner target.
6. Initialize Firebase in `main.dart` with `DefaultFirebaseOptions.currentPlatform`.

Manual actions required from the project owner:

1. Enable the **Email/Password** provider in Firebase Console (Authentication > Sign-in method).
2. Authorize/review platform app registration if FlutterFire requests it.
3. No new Firebase project is created; no billing change is required for email/password.

Failure handling: never claim Firebase connectivity; all auth requests handle failures even when `connectivity_plus` reports online.

## 9. Core Foundation

- Cairo TTF files bundled in `assets/fonts/` and set as the default font family (Google Fonts Cairo, OFL license).
- `ThemeData` (Material 3) built only from centralized tokens.
- Arabic-first: `locale: ar`, `GlobalMaterialLocalizations`, RTL verified per screen.
- Centralized Arabic strings in `core/constants/app_strings.dart`.
- Shared widgets listed in section 6; no speculative abstractions.
- Responsive: max content width ~480 centered, adaptive padding, scrollable forms, `resizeToAvoidBottomInset`, SafeArea, text-scale tolerance. No fixed screen dimensions.
- Errors: typed `Failure` (validation/auth/network/unknown); Firebase codes mapped to Arabic messages; raw exceptions/codes/stack traces never shown to users.

## 10. Onboarding

Storage: `core/storage/onboarding_status_store.dart`

- Key `onboarding_completed` in SharedPreferences.
- `bool get isCompleted`; `Future<void> markCompleted()`.
- Shared by `OnboardingBloc` (write) and `SessionBloc` (read); single source of truth.

`OnboardingBloc` (presentation only, depends only on the store):

- Events: `OnboardingStarted`, `OnboardingPageChanged`, `OnboardingNextPressed`, `OnboardingSkipped`, `OnboardingFinished`.
- State: `currentPage`, `isCompleted`, `isSubmitting`.
- Writes the flag only on Skip or Finish.
- The page uses `BlocListener` for the one-off completion effect, dispatching `SessionOnboardingCompleted` to `SessionBloc`. No navigation inside `BlocBuilder`.

UI: 3 slides matching references; `smooth_page_indicator` pill style; Skip on pages 1–2 only; Next on 1–2; Finish ("ابدأ الآن") on page 3; RTL layout preserved.

## 11. Authentication

Data:

- `FirebaseAuthDataSource`: `signInWithEmailAndPassword`, `createUserWithEmailAndPassword`, `sendPasswordResetEmail`, `authStateChanges`.
- `AuthRepositoryImpl` implements the domain contract and returns `Either<Failure, T>`.
- `FirebaseAuthException` codes mapped to typed failures and user-friendly Arabic messages.

Login: formz email/password; loading and failure states; duplicate submits blocked; session reflected automatically through auth-state stream.

Registration: name, email, password, confirm password, terms checkbox (only fields present in the reference). Confirm password revalidates whenever either password field changes. Duplicate email, weak password, invalid email mapped to Arabic messages. No invented profile fields.

Forgot/Reset password:

1. Validate email.
2. Call `sendPasswordResetEmail` through the data layer.
3. Loading state; duplicate requests blocked.
4. On success: Arabic confirmation, then start a 60-second countdown.
5. Countdown starts only after success; resend disabled with remaining time, then relabeled for resend.
6. On failure: Arabic error; countdown not started or reset.
7. Timer cancelled on `close()`; raw exceptions never exposed.

## 12. Session and Routing

`SessionBloc` (core/session):

- State: `status { unknown, unauthenticated, authenticated }` + `onboardingCompleted`.
- Starts `unknown`; reads `OnboardingStatusStore` and subscribes to `authStateChanges`.
- Reacts to `SessionOnboardingCompleted`.

GoRouter (core/routing): single redirect source of truth, refreshed via `GoRouterRefreshStream(SessionBloc)`:

1. `unknown` → Splash (no wrong-screen flash).
2. Onboarding not completed → Onboarding.
3. Onboarding completed + unauthenticated → Login.
4. Onboarding completed + authenticated → Home.

No redirect loops, no per-screen session checks, no navigation inside `BlocBuilder`.

## 13. Assets

- `assets/fonts/Cairo-Regular.ttf`, `Cairo-Medium.ttf`, `Cairo-SemiBold.ttf`, `Cairo-Bold.ttf` (Google Fonts Cairo, OFL).
- `assets/images/` reserved for owner-supplied logo/illustration assets (none supplied yet).
- No image assets are invented: splash/onboarding/auth visuals are composed from approved tokens, shapes, gradients, and Material icons.
- Asset paths centralized in `core/constants/app_assets.dart`.

## 14. File Changes

Modify:

- `pubspec.yaml` (dependencies, assets, fonts).
- `lib/main.dart` (Firebase init, `initDependencies()`, root providers, `MaterialApp.router`).
- `test/widget_test.dart` (replace counter smoke test).
- Android Gradle/manifest and iOS target/plist only as Firebase requires.

Create: every file listed in section 6; `assets/fonts/*`; `IMPLEMENTATION_STATUS.md`.
Generated: `lib/firebase_options.dart`, `android/app/google-services.json`, `ios/Runner/GoogleService-Info.plist`.
Preserve unchanged: `AGENTS.md`, `PROMPT_PHASE_1_PLAN.md`, `ui_phase_1/*`, platform scaffolding, `.metadata`, `analysis_options.yaml`, `README.md`.

## 15. Verification

- `dart format --set-exit-if-changed .`
- `flutter analyze` (zero issues)
- `flutter test`
- Unit tests: value validators, auth error mapper, Login/Register/ForgotPassword BLoC transitions, SessionBloc startup priority, OnboardingBloc persistence semantics.
- Widget tests: onboarding navigation and completion trigger, form validation/loading/error states.
- Manual scenarios: cold start with/without completed onboarding; kill during onboarding (must reappear); skip persists; login success/failure; duplicate/weak/invalid registration; reset success + countdown; offline handling; RTL and text scaling.
- Report checks as passed / failed / not run; Firebase-dependent flows are verified only after configuration and provider enablement.

## 16. Resolved Decisions (previously open)

1. Home: **placeholder** in Phase 1 (`home_placeholder_page.dart`); full `home.jpg` is a later phase.
2. Application id: keep `com.example.tathakkar` (minimal-change principle; change needs owner approval).
3. FlutterFire platforms: **Android + iOS** only.
4. Cairo font: downloaded from Google Fonts (OFL) and bundled.
5. Image assets: none supplied → visuals composed from tokens/icons; supplied assets are never replaced.
6. Localization: centralized Arabic string constants (no ARB/intl codegen).
7. `register.jpg` "2/59" badge: meaning unknown → **not rendered** (inventing is forbidden; owner confirmation requested separately).
8. Forgot-password buttons: initial primary "إرسال"; secondary "إعادة الإرسال" disabled during countdown, relabeled/enabled when the countdown ends.
9. Splash: shown as a Flutter route while session state resolves; native launch screen left unchanged.

## 17. Implementation Order

1. Create and verify `PHASE_1_APPROVED_PLAN.md`; initialize `IMPLEMENTATION_STATUS.md`.
2. Add dependencies, Cairo fonts, assets; `flutter pub get`.
3. FlutterFire configure against `tathakkar-4d181`; Android/iOS platform configuration.
4. Core: tokens, theme, Cairo, localization/RTL, responsive utilities, shared widgets, error mapping, validators.
5. `lib/core/di/injection_container.dart` and `lib/core/storage/onboarding_status_store.dart`.
6. `SessionBloc` + GoRouter + Splash route.
7. Onboarding presentation.
8. Auth data + domain layers.
9. Auth presentation: login, register, forgot password.
10. Home placeholder + route wiring + `main.dart`.
11. Tests; `dart format`; `flutter analyze`; `flutter test`; manual verification; honest report.
