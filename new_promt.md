# CRITICAL BUG FIX — ONBOARDING PERSISTENCE AND SESSION INITIALIZATION

You are a senior Flutter engineer working on my existing Flutter project.

The onboarding screen is still displayed on every application launch, even after the user has completed or skipped onboarding. Previous attempts to fix this issue did not resolve it.

Your task is to investigate the existing implementation, identify the exact root cause, and fix the startup/session logic so that onboarding is displayed only when appropriate.

**Modify only the code strictly necessary to fix this bug. Do not modify anything else.**

## 1. Files to Inspect First

Start by inspecting these exact files and their directly relevant dependencies:

1. `lib/core/session/`
2. `lib/features/onboarding/presentation/bloc/`
3. `lib/features/onboarding/presentation/pages/onboarding_page.dart`
4. `lib/core/routing/app_router.dart`

Inspect all relevant files within the specified directories, not just one file from each directory.

If necessary, follow the existing call chain into the splash screen, application initialization, dependency injection, session storage, or authentication-state handling. Inspect additional files only when they are directly relevant to understanding the bug.

Do not edit any files until you understand how the current session and onboarding state are initialized, persisted, and consumed by the router.

## 2. Required Startup Behavior

The application must distinguish correctly between onboarding completion and authentication status.

### Scenario A — First installation

When the application is installed for the first time and launched:

1. Display the existing splash screen.
2. Display the onboarding pages.
3. Allow the user to navigate through onboarding normally.

Onboarding must remain visible until the user explicitly completes it or presses Skip.

### Scenario B — User completes onboarding but does not log in

When the user reaches the end of onboarding and proceeds to Login:

1. Persist the onboarding completion state.
2. Navigate to Login using the existing routing conventions.
3. If the user closes and reopens the application without logging in, display the splash screen followed by Login.
4. Do not display onboarding again.

### Scenario C — User skips onboarding without logging in

When the user presses Skip:

1. Persist the onboarding completion state immediately and reliably.
2. Navigate to Login.
3. If the application is subsequently closed and reopened before login, display the splash screen followed by Login.
4. Do not display onboarding again.

Skipping and completing onboarding must produce the same persisted onboarding-completion state.

### Scenario D — Authenticated user

When the user has successfully logged in and the authentication session remains valid:

1. Display the existing splash screen.
2. Restore or verify the authentication session using the existing authentication mechanism.
3. Navigate directly to Home after initialization.
4. Do not display onboarding or Login unnecessarily.

### Scenario E — Existing user who has completed onboarding but is signed out

If onboarding was completed previously but the user is no longer authenticated, display the splash screen followed by Login.

Do not reset onboarding completion simply because the user logs out or has no active authentication session.

## 3. Diagnose the Actual Root Cause

Do not assume the problem is caused by the router alone or by missing persistence.

Trace the complete state lifecycle:

- Initial session state.
- Loading and initialization of persisted session data.
- The onboarding completion flag and its default value.
- The code executed when the user presses Skip.
- The code executed when the user completes onboarding.
- The exact point at which onboarding completion is persisted.
- The Bloc events, states, and handlers involved in onboarding.
- How `onboarding_page.dart` dispatches events and responds to state changes.
- How `app_router.dart` chooses the initial route or redirects between routes.
- Whether the router reads the session before initialization finishes.
- Whether a default or loading state incorrectly routes users to onboarding.
- Whether the completion state is overwritten, reset, or lost during application startup.
- Whether asynchronous initialization, Bloc recreation, dependency injection, or router refreshes cause the completed state to be ignored.

These are diagnostic checks, not predetermined explanations. Confirm the actual cause from the code.

**Important:** Do not introduce another onboarding flag or a second session-management mechanism before checking whether the existing implementation already has one.

## 4. Implement the Smallest Correct Fix

After identifying the root cause:

- Correct the existing session initialization and onboarding persistence logic.
- Ensure the persisted completion state is loaded before the router makes its final startup decision.
- Ensure the router does not interpret an uninitialized or loading session as a first-time user.
- Ensure Skip and Finish both update the same authoritative onboarding-completion state.
- Ensure the completion state is persisted before navigating away from onboarding.
- Ensure that subsequent application launches use the persisted state rather than resetting it to the initial value.
- Preserve the separation between onboarding completion and authentication status.
- Ensure startup routing is deterministic and does not trigger conflicting or repeated navigation.
- Use the existing storage abstraction, Bloc architecture, and dependency injection wherever possible.
- Follow the project's existing error-handling and asynchronous programming conventions.

If the existing implementation already contains the required persistence mechanism, fix its usage, initialization order, or state propagation instead of introducing a replacement mechanism.

If persistence is genuinely missing, implement only the minimum necessary persistence using the project's existing storage conventions.

Do not solve this problem by adding arbitrary delays, forcing onboarding to be skipped, hardcoding the Login route, or making onboarding appear only under a temporary in-memory condition.

Do not modify the visual design or the existing onboarding navigation behavior beyond what is necessary to fix the bug.

## 5. Strict Change Restrictions

The following rules are mandatory:

1. Fix only the onboarding persistence, session initialization, and startup-routing defect.
2. Preserve the existing project architecture and all unrelated code.
3. Do not redesign or modify any UI.
4. Do not change unrelated authentication logic, Firebase configuration, business logic, repositories, data models, or use cases.
5. Do not change the existing splash screen's design or duration unless strictly necessary to fix this specific defect.
6. Do not refactor, rename, reorganize, or clean up unrelated code.
7. Do not add unnecessary dependencies, flags, services, abstractions, or state variables.
8. Do not modify the Login, Register, Forgot Password, or Home UI.
9. Do not revert or overwrite existing user changes.
10. Do not make speculative changes to files that have not been shown to require modification.

If a change outside the directly related session/onboarding/routing implementation appears necessary, explain why and ask for approval before making it.

## 6. Mandatory Verification

Verify the actual state transitions, not merely whether the code compiles.

Test or trace these sequences:

**Test 1: Complete onboarding**

Fresh installation → Splash → Onboarding → Finish → Login → Close application → Relaunch → Splash → Login.

**Test 2: Skip onboarding**

Fresh installation → Splash → Onboarding → Skip → Login → Close application → Relaunch → Splash → Login.

**Test 3: Authenticated session**

Complete onboarding → Login → Successfully authenticate → Home → Close application → Relaunch → Splash → Home.

**Test 4: Sign out**

Previously completed onboarding → Sign out → Close application → Relaunch → Splash → Login, without showing onboarding again.

**Test 5: Incomplete onboarding**

Fresh installation → Splash → Onboarding → Close application before completing or skipping → Relaunch → Splash → Onboarding.

The incomplete-onboarding behavior must remain consistent with the existing intended product behavior.

Run `flutter analyze` and inspect the final Git diff if Git is available. Do not fix unrelated pre-existing issues.

If you cannot run the application, clearly distinguish between behavior verified by code inspection and behavior tested at runtime.

## 7. Final Report

After the fix, provide:

- The exact root cause of the recurring onboarding issue.
- The exact files modified.
- The specific correction made in each modified file.
- How onboarding completion is persisted and restored.
- How startup routing now distinguishes first-time, signed-out, and authenticated users.
- The verification results and any remaining limitations.

**NON-NEGOTIABLE FINAL RULE: Do not make any additional changes. Diagnose the actual bug in the existing implementation, fix its root cause with the smallest possible code change, and preserve everything else exactly as it is.**