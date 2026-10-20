# Tathakkar — Phase 1 Planning Prompt

You are a senior Flutter software architect and mobile application engineer.

Your task is to analyze the existing Tathakkar project and prepare a detailed, implementation-ready plan for Phase 1.

**IMPORTANT: This is a planning-only task. Do not modify files, install packages, run commands that change the project, or implement anything.**

## 1. Mandatory Instructions and References

Before doing anything else:

1. Read the entire `AGENTS.md` file from beginning to end.
2. Treat every applicable rule in `AGENTS.md` as mandatory.
3. Inspect the existing project structure and current implementation before proposing changes.
4. Inspect all files in `ui_phase_1` and identify the provided UI references for Onboarding and Authentication.
5. Do not assume file names, folder structures, dependencies, or existing implementations without inspecting the actual project.
6. Do not invent UI elements, features, colors, behaviors, or requirements that are not supported by the provided references or explicit requirements.
7. If a requirement is ambiguous, contradictory, or impossible to verify from the available files, identify it clearly and ask me for clarification rather than guessing.
8. Do not expand the scope beyond Phase 1.
9. Preserve useful existing code and configuration whenever possible.
10. Do not create a new Flutter project or a new Firebase project.

## 2. Existing Firebase Project

The Firebase project already exists and its project ID is:

`tathakkar`

The implementation must use this existing Firebase project.

During planning:

1. Inspect `pubspec.yaml`, `firebase_options.dart` if present, and existing Android, iOS, and other relevant Firebase configuration files.
2. Determine whether Firebase has already been configured and whether the Flutter application appears to be connected to the existing `tathakkar` project.
3. Identify missing or inconsistent configuration without modifying it.
4. Plan the minimum necessary Firebase setup.
5. Identify whether FlutterFire CLI configuration is required. Do not run `flutterfire configure` during this planning phase.
6. Plan to use Firebase Authentication for actual registration, login, password-reset requests, and authentication-state observation.
7. Plan to use the existing Firebase project rather than creating or replacing it.
8. Identify any external action that may require my involvement, such as enabling Email/Password authentication in the Firebase Console, obtaining permissions, or providing platform-specific configuration.

Do not claim that Firebase is correctly configured unless the existing files provide sufficient evidence.

## 3. Phase 1 Scope

Phase 1 consists of:

- Core application foundation.
- Design system derived from the supplied UI references.
- Responsive layout foundation.
- Shared reusable widgets.
- Arabic localization and RTL support.
- Cairo font integration.
- Application routing using GoRouter.
- Onboarding screens.
- Login screen.
- Registration screen.
- Forgot/reset password screen.
- Form validation.
- Firebase Authentication integration.
- Authentication session-state management.
- Onboarding completion persistence.
- Loading, error, empty, and success states required by these screens.
- Integration with the appropriate next destination without implementing unrelated features.

Do not implement the complete Home feature or any unrelated application modules. If no approved Home UI exists, plan only the minimum safe destination or placeholder necessary for routing integration, and ask me if a real Home screen is required now.

## 4. Core Foundation Analysis

Inspect the UI references and plan the shared foundation before implementing individual screens.

### 4.1 Design System

Extract the actual design specifications from the supplied references, including:

- Primary and secondary colors.
- Background colors and background effects.
- The subtle glass-like visual treatment used in the references.
- Typography, font sizes, weights, and hierarchy.
- Spacing and sizing rules.
- Border radii.
- Borders, shadows, and other visual treatments.
- Button styles.
- Input-field styles.
- Icons and visual assets where available.
- Layout constraints and alignment.
- RTL behavior.

Create a centralized design-token plan for colors, typography, spacing, radii, and other reusable design properties.

Do not invent alternative branding or introduce colors merely because they are common in healthcare applications.

### 4.2 Cairo Font

Plan the correct integration of the Cairo font.

- Check whether the font already exists in the project.
- If it does not exist, identify a reliable way to obtain the required font files and add them to the project.
- Configure the font centrally in the application theme.
- Ensure Arabic text renders correctly and consistently.
- Avoid downloading or adding duplicate font files.

### 4.3 Responsive Layout

Analyze the reference dimensions and plan layouts that adapt appropriately to mobile phones and tablets.

Evaluate suitable responsive-layout packages or Flutter-native solutions. Recommend a dependency only if it provides meaningful value.

The implementation must avoid:

- Hardcoded screen dimensions that break on other devices.
- Overflow and clipped content.
- Keyboard-obscured form fields.
- Inconsistent spacing between screen sizes.
- Unnecessary package dependencies.

### 4.4 Shared Components

Identify reusable components that belong in `core`, such as:

- Common buttons.
- Common input fields.
- Consistent loading indicators.
- Reusable error and success presentation.
- Shared layout or background components when justified by the references.
- Centralized spacing and responsive utilities.

Do not create abstractions for components that are not genuinely shared.

### 4.5 Localization and RTL

Plan Arabic-first localization and right-to-left layout support.

- Keep user-facing Arabic strings centralized.
- Avoid scattering raw Arabic strings throughout the application.
- Ensure text alignment, icons, navigation, and form layouts respect RTL.
- Follow the project's existing localization setup if one is already present.
- Avoid introducing an unnecessary localization architecture.

## 5. Architecture and Engineering Rules

Follow `AGENTS.md` and apply the following principles:

- Clean Architecture with clear separation between `presentation`, `domain`, and `data`.
- A shared `core` layer for genuinely cross-cutting concerns.
- Clean Code and SOLID principles.
- Reusability and maintainability.
- No overengineering.
- Dependency injection only to the extent justified by the project.
- Separation of UI, business logic, and external services.
- No Firebase SDK calls directly inside widgets or presentation-layer UI code.
- Do not introduce unnecessary design patterns or abstractions.

### State Management

Use BLoC with explicit Events, States, and Bloc classes.

Cubit is not allowed unless I explicitly approve it.

Plan the appropriate BLoCs for:

- Onboarding state and completion.
- Authentication actions and form submission states.
- Authentication session observation and routing decisions.

Avoid combining unrelated responsibilities into one oversized BLoC.

### Error Handling

Plan a consistent error-handling strategy.

- Use `dartz` where it provides a meaningful Result/Either-based error flow.
- Avoid forcing `dartz` into every method without justification.
- Translate Firebase Authentication exceptions into clear, user-friendly Arabic messages.
- Never expose raw exceptions, stack traces, internal implementation details, or technical error codes directly to users.
- Preserve enough diagnostic information for development without exposing sensitive data.
- Distinguish validation errors, authentication errors, connectivity problems, and unexpected failures.

### Form Validation

Use `formz` for form validation where appropriate.

Plan reusable validation rules for:

- name
- Email.
- Password.
- Password confirmation.
- Required fields.

Registration password confirmation must update immediately when either password field changes, with a clear and consistent validation state.

## 6. Dependencies to Evaluate

Inspect the existing dependencies before recommending or adding anything.

Evaluate these packages for Phase 1:

- `flutter_bloc`
- `formz`
- `dartz`
- `go_router`
- `shared_preferences`
- `connectivity_plus`
- `smooth_page_indicator`
- `firebase_core`
- `firebase_auth`

Use existing compatible packages when already installed.

For every additional dependency, explain its purpose, necessity, and compatibility with the project's Flutter/Dart versions.

Do not add duplicate packages or introduce unnecessary dependencies.

Important: `connectivity_plus` reports network connectivity status but does not prove that Firebase or another remote service is reachable. Plan appropriate handling of failed requests even when connectivity appears available.

## 7. Onboarding Requirements

Analyze all Onboarding UI references in `ui_phase_1`.

Plan the implementation so that:

1. The screens closely match the provided references.
2. The page indicator uses `smooth_page_indicator` if compatible and appropriate.
3. Users can navigate through the onboarding pages.
4. Users can skip onboarding if the supplied UI and requirements include a Skip action.
5. Completing or skipping onboarding permanently marks it as completed using `shared_preferences`.
6. Once completed or skipped, onboarding must not appear again on subsequent launches, including launches where the user has not logged in.
7. If the application is closed before the user completes or skips onboarding, it must appear again on the next launch.
8. The persistence logic must not incorrectly mark onboarding as complete merely because the application was opened.
9. BLoC must manage the relevant state and interactions.
10. The implementation must avoid race conditions between reading onboarding status and deciding the initial route.

Do not invent extra onboarding pages or change the supplied content.

## 8. Authentication Requirements

Analyze the supplied Login, Registration, and Forgot/Reset Password references.

Plan actual Firebase Authentication integration for the existing `tathakkar` project.

### 8.1 Login

- Validate the form using `formz` where appropriate.
- Authenticate through Firebase Authentication.
- Handle loading, success, and failure states.
- Display understandable Arabic error messages.
- Handle invalid credentials and relevant Firebase authentication errors.
- Prevent duplicate submissions while a request is in progress.
- Ensure the authentication session is reflected by the session-management mechanism.

### 8.2 Registration

- Validate required fields, email, and password.
- Confirm password equality immediately as either password field changes.
- Register using Firebase Authentication.
- Handle duplicate email, weak password, invalid email, and other relevant errors.
- Display Arabic success or failure feedback.
- Prevent duplicate requests.
- Do not invent profile fields or additional registration requirements that are not specified by the UI references or project requirements.

### 8.3 Forgot/Reset Password

Use Firebase Authentication's password-reset email mechanism.

Required behavior:

1. Validate the email before submitting.
2. Call `sendPasswordResetEmail` through the data layer.
3. Show a loading state and prevent duplicate requests while the request is running.
4. On success, show a clear Arabic confirmation message.
5. Start a 60-second countdown only after the reset-email request succeeds.
6. During the countdown, disable the resend action and display the remaining time.
7. When the countdown reaches zero, enable the action again and change its label to the appropriate Resend wording.
8. If the request fails, do not start or reset the countdown.
9. Display a user-friendly Arabic error message when sending fails.
10. Cancel or dispose of any timer correctly when the relevant BLoC or screen is disposed.
11. Do not expose raw Firebase exceptions.

The application must not claim that an email was sent unless Firebase reports the request as successful.

## 9. Authentication Session and Initial Routing

Plan a clear startup decision flow.

The application must distinguish between:

- Whether onboarding has been completed.
- Whether a Firebase user is authenticated.
- Whether the authentication state is still loading or being resolved.

Required priority:

1. When onboarding has not been completed, show Onboarding.
2. When onboarding has been completed but the user is not authenticated, show Login.
3. When onboarding has been completed and the user is authenticated, navigate to the appropriate Home destination.
4. During startup, avoid briefly displaying the wrong screen while onboarding preferences or Firebase authentication state are loading.

Use Firebase Authentication's authentication-state stream to observe session changes.

A shared Session BLoC or equivalent BLoC-based session manager should coordinate authentication-state observation and routing. Place it in the most appropriate shared layer based on the inspected project structure.

Use GoRouter redirects or an equivalent clean routing mechanism. Avoid redirect loops, conflicting navigation calls, and duplicated session checks across screens.

Do not implement a full Home feature without approved requirements and UI references.

## 10. Firebase Integration and Security

Plan a clean separation between:

- Authentication presentation logic.
- Authentication domain contracts and use cases, where justified.
- Firebase Authentication data-source operations.
- Repository implementation and error mapping.
- Session-state observation.

Use the existing Firebase project `tathakkar`.

Do not create a new Firebase project, replace the current project, or overwrite valid configuration unnecessarily.

Inspect Firebase configuration for the relevant platforms before deciding whether `flutterfire configure` is needed.

Do not expose secrets or commit credentials.

Identify any manual Firebase Console action that may be necessary, particularly enabling the Email/Password sign-in provider.

## 11. Planning Deliverables

Return a detailed, implementation-ready plan with these sections:

1. **Current Project Assessment** — existing structure, dependencies, configuration, and findings.
2. **UI Reference Analysis** — screen inventory and extracted design specifications.
3. **Firebase Readiness Assessment** — whether the existing configuration appears to target `tathakkar`, what is missing, and any required manual actions.
4. **Proposed Architecture** — actual proposed folders, responsibilities, and data flow based on the inspected project.
5. **Dependency Plan** — existing packages to reuse and packages to add, with justification.
6. **Core Implementation Plan** — theme, Cairo font, design tokens, localization, RTL, responsive utilities, shared widgets, and error handling.
7. **Onboarding Implementation Plan** — screens, BLoC responsibilities, persistence, and startup behavior.
8. **Authentication Implementation Plan** — Login, Registration, Forgot/Reset Password, validation, repositories, data sources, and Firebase errors.
9. **Session and Routing Plan** — session BLoC, startup priority, GoRouter redirects, and loop prevention.
10. **File-by-File Change Plan** — specific files to create, modify, or preserve, based on actual inspection.
11. **Verification Plan** — formatting, analysis, tests, and manual scenarios.
12. **Risks and Questions** — ambiguities, platform limitations, or decisions requiring my approval.
13. **Ordered Execution Checklist** — small, verifiable implementation steps in the correct dependency order.

Be specific. Avoid generic architectural advice.

Do not modify any files, install dependencies, or begin implementation until I explicitly approve the plan.

Finish by presenting the plan and waiting for my approval or requested revisions.
