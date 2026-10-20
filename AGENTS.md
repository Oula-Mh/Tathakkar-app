# Tathakkar — Mandatory Engineering Rules

## 1. Purpose and Authority

This document defines the mandatory engineering rules for the Tathakkar Flutter application. It is the persistent source of truth for engineering practices and project-wide constraints.

Before starting **every task**, you MUST read this document in full and follow it. Do not rely on conversation history, assumptions, or memory as a substitute for this file. If the task spans multiple sessions or the AI model changes, these rules remain applicable.

The task-specific instructions and approved UI references supplied by the project owner define what must be implemented in that task. This document defines how the work must be carried out. Follow both. Do not interpret this document as permission to implement features that were not requested.

If a task instruction appears to conflict with this document, stop before making the conflicting change, explain the conflict, and ask the project owner which instruction should take precedence. Do not silently choose.

## 2. Strict Scope Control — Do Only What Is Requested

- Implement only the functionality explicitly requested for the current task.
- Do not invent, assume, expand, redesign, or add product requirements.
- Do not add extra screens, fields, buttons, actions, flows, settings, permissions, validation rules, messages, or behaviors unless they are explicitly required or approved.
- Do not implement future features just because they are mentioned in the project overview or seem useful.
- Do not make unrelated refactors, rename unrelated files, reorganize unrelated folders, or change existing behavior outside the task's scope.
- Do not add packages, services, design patterns, abstractions, or infrastructure without a clear need for the requested task.
- If an improvement seems useful, describe it separately and request approval. Never apply it automatically.
- Preserve existing working behavior unless the task explicitly requires changing it.
- Make the smallest complete change that satisfies the requirements without compromising architecture, correctness, or maintainability.

## 3. Ask Before Guessing

Correctness is more important than guessing or rushing.

You MUST ask the project owner for clarification before implementing any part that depends on:
- Missing or ambiguous functional requirements.
- Conflicting instructions or UI references.
- Unspecified user permissions, business rules, edge cases, or data behavior.
- An unresolved decision listed in the project overview.
- A technical limitation that would require changing the requested behavior or UI.
- A decision that could materially affect data integrity, security, privacy, architecture, or user experience.

When something is unclear:
1. State exactly what is unclear.
2. Explain briefly why a decision is required.
3. Ask a focused question, offering options when useful.
4. Do not implement the ambiguous behavior until it is clarified.

You may continue work on clearly specified, independent parts only when doing so cannot prejudge or constrain the unresolved decision. Otherwise, pause and wait. Never hide assumptions inside the implementation.

Do not ask questions whose answers are already explicitly provided in the current task, this document, or approved project documentation.

## 4. UI Reference Fidelity

Approved UI screenshots, mockups, or design files provided for a task are the authoritative visual reference for that task. Follow them closely and in detail.

- Reproduce the provided layout, hierarchy, alignment, sizing, spacing, typography, colors, icons, borders, corner radii, shadows, imagery, and visible states as accurately as reasonably possible.
- Do not redesign, modernize, simplify, embellish, or reinterpret the approved UI based on personal preference.
- Do not add, remove, rename, or reposition visible elements unless required by the reference or explicitly approved.
- Do not invent missing screens, controls, copy, icons, illustrations, or interactions.
- Preserve Arabic content, right-to-left (RTL) direction, and text alignment as specified by the design.
- Account for the reference's visible loading, empty, error, disabled, and success states when they are shown or specified.
- Do not replace a supplied asset with a different asset without approval.
- Do not approximate a reference detail if it can be inspected accurately. Inspect the provided files and images at an appropriate level of detail.
- Use responsive layouts to preserve the intended design across supported screen sizes; responsiveness must not be used as an excuse to alter the design unnecessarily.
- If the reference is incomplete, unreadable, contradictory, or technically infeasible, ask the project owner before inventing a solution.
- After implementation, compare the result with the reference and report any known visual differences honestly.

The first project setup task will establish the app's design tokens and shared UI rules from the supplied references. Until those tokens are established, do not invent project-specific colors, fonts, or design values. Once approved, reuse them consistently across all features unless the project owner explicitly changes them.

## 5. Project Overview and Product Constraints

Tathakkar is an Arabic-first medication management and family-care application built with Flutter and Firebase. Its intended capabilities include personal medication management, medication reminders, dose confirmation and history, stock tracking, family profiles on the same device, and remote caregiver relationships.

The following decisions are approved project constraints:

- Users begin with personal medication management. Do not ask them to choose an elderly-user or caregiver role during registration.
- Care permissions are based on the relevant person/profile and their active caregiver relationship, not simply on age or a global account role.
- The application supports managing separate family profiles on the same device.
- Remote care uses separate accounts linked through a temporary, single-use QR code.
- A care recipient has only one active remote caregiver at a time.
- Under the currently approved flow, scanning a valid QR code links the accounts without an additional approval step.
- While the remote caregiver relationship is active, the caregiver manages the care recipient's medication records; the care recipient can view medications and interact with reminders but cannot add, edit, or delete those medication records.
- When the remote relationship is disconnected, the care recipient regains personal medication-management permissions. Existing records, schedules, and history must be preserved.
- Disconnecting one relationship must not affect other profiles or care relationships managed by the same caregiver.
- Snoozing or dismissing a reminder is not confirmation that a dose was taken.
- A dose is confirmed only through an explicit confirmation action by the person taking it or a caregiver who actually administered it.
- Medication stock is deducted only after a valid dose confirmation.
- The unconfirmed-dose alert is based on 30 minutes after the original scheduled dose time. Snoozing does not reset this timer.
- Medication treatment end dates and remaining stock are separate concepts. An ended treatment does not necessarily mean the stock is empty.
- Low-stock alerts use a configured threshold; do not invent a default threshold unless it is explicitly specified for the current task.
- Local reminders and locally stored data should support offline use where technically supported. Remote synchronization requires connectivity.
- A QR code used for linking must be temporary, single-use, and must not expose health data or passwords.

Some product decisions remain unresolved, including snooze durations, low-stock default behavior where no threshold is set, detailed unlinking policy, conflict resolution between devices, and exact full-screen/audio reminder behavior across Android and iOS. Do not decide these independently. Ask the project owner whenever a task requires one of these decisions and it has not yet been approved.

This overview does not authorize implementation of all listed capabilities at once. Implement only the feature or stage explicitly requested in the current task.

## 6. Required Architecture — Clean Architecture

Use Clean Architecture with three clearly separated layers: `presentation`, `domain`, and `data`, plus a shared `core` for genuinely cross-cutting functionality.

Organize features so that each feature owns its related code and responsibilities, with `domain`, `data`, and `presentation` kept separate within the feature where appropriate. Follow the structure established by the approved project setup; do not independently restructure it.

### 6.1 Domain

The domain layer contains business rules and application concepts that must not depend on Flutter UI, Firebase, platform APIs, or data-layer implementations.

- Place entities and business rules in the domain layer.
- Define repository contracts/abstractions in the domain layer when needed.
- Use cases should represent meaningful application actions or business operations.
- Do not create a separate use case or abstraction for every trivial operation without a clear benefit.
- Keep domain logic independent of external frameworks wherever practical.

### 6.2 Data

The data layer implements the domain contracts and handles persistence and external data access.

- Place data models, data sources, data mapping, and repository implementations here.
- Keep Firebase SDK calls and other infrastructure-specific details out of the domain and presentation layers.
- Map Firebase responses and failures into appropriate application/domain representations.
- Handle loading, empty, malformed, missing, and failed data appropriately where relevant.
- Do not silently swallow exceptions or convert failures into misleading success results.
- Do not duplicate business rules across data sources, repositories, and UI.

### 6.3 Presentation

The presentation layer contains screens, widgets, and presentation state management.

- Widgets render state and dispatch user actions; they must not contain substantial business logic.
- Presentation must not call Firebase or data sources directly.
- Use BLoC as defined in Section 7.
- Keep widgets focused, readable, and reusable when reuse is justified.
- Separate visual components from feature logic when doing so improves clarity without unnecessary abstraction.

### 6.4 Dependency Direction

- Presentation may depend on domain abstractions.
- Data implements abstractions defined by domain.
- Domain must not depend on data or presentation.
- Do not bypass layers for convenience.
- Dependency injection must be configured in a clear, consistent location and must not leak service-locator calls throughout business logic unnecessarily.

## 7. Mandatory State Management — BLoC

Use the BLoC pattern for feature state management. A BLoC consists of Events, States, and a Bloc that handles events and emits states.

- Events represent meaningful actions or requests.
- States represent the UI-relevant state of the feature.
- BLoCs coordinate use cases and presentation state; they must not contain direct Firebase SDK calls or become repositories.
- Use immutable states and events.
- Use consistent, descriptive naming for events, states, and BLoCs.
- Model loading, success, empty, and error outcomes as required by the feature.
- Preserve relevant data when transitioning between states where appropriate.
- Do not place navigation, dialogs, snackbars, or other one-off UI effects inside `BlocBuilder`.
- Use `BlocBuilder` for rendering state and `BlocListener` for one-time effects when appropriate.
- Provide and dispose/manage BLoC instances according to their intended lifecycle.
- Do not create duplicate BLoCs or competing sources of truth for the same state without a clear reason.
- Follow the project's approved conventions for `Equatable` or another state equality mechanism; do not introduce multiple competing approaches.
- Test meaningful state transitions and important event handling.
- Use Cubit only if explicitly approved for a specific reason; BLoC with Events, States, and Bloc is the required default.

## 8. Clean Code, SOLID, and Maintainability

All code must be clear, cohesive, testable, and maintainable.

- Use descriptive, consistent names that communicate intent.
- Keep each class and function focused on a clear responsibility.
- Prefer small, understandable functions and avoid deeply nested logic where practical.
- Avoid duplicated logic; extract shared code only when there is a real reuse or clarity benefit.
- Keep UI widgets free from business rules and infrastructure concerns.
- Avoid magic values. Use named constants or centralized design tokens for values that genuinely need to be shared or controlled.
- Validate user input at the appropriate boundary.
- Handle errors explicitly and provide meaningful failure states.
- Do not use empty catch blocks, ignored futures, unexplained forced unwraps, or broad suppression of analyzer warnings.
- Avoid unnecessary global mutable state and hidden side effects.
- Follow SOLID where it improves separation of responsibility, extension, substitutability, interface clarity, and dependency inversion.
- Do not create interfaces, factories, managers, base classes, or layers without a justified need.
- Prefer composition over inheritance when suitable.
- Do not sacrifice correctness or readability merely to reduce line count.
- Follow established Dart and Flutter conventions and the existing project lint rules.
- Add comments to explain non-obvious reasoning, constraints, or decisions, not to restate obvious code.
- Do not leave placeholder implementations, fake data, TODOs, or hard-coded demo behavior in a feature presented as complete unless the task explicitly requests a prototype.

## 9. Design Patterns and Reusability

- Use design patterns only when they solve an actual problem in the requested scope.
- Repository and dependency-injection patterns should support the agreed architecture; do not apply patterns mechanically.
- Prefer shared widgets, utilities, and design tokens when they are genuinely shared.
- Avoid both extremes: duplicating stable shared behavior and creating generic frameworks for one-off needs.
- Do not create speculative abstractions for hypothetical future features.
- Do not introduce a second approach when the project already has an approved, suitable approach.

## 10. UI System, Localization, and Responsiveness

- Follow the design tokens and shared components established during the initial UI/core task.
- Use the approved font families, text styles, color palette, spacing, sizing, radii, and component styles consistently.
- Do not hard-code repeated design values throughout feature widgets when an approved token exists.
- Support Arabic and RTL correctly across layouts, navigation, text, icons where direction matters, and input fields.
- Do not assume that setting the whole app to RTL fixes every component; verify individual layouts and directional behavior.
- Use responsive layouts that accommodate supported device sizes and text scaling while preserving the reference design.
- Avoid fixed dimensions that cause clipping or overflow on supported screens unless the reference and device constraints explicitly require them.
- Ensure accessible touch targets, legible text, and clear visual hierarchy consistent with the approved UI.
- Do not introduce a new theme, font, color, or UI library without approval.

## 11. Firebase, Data Integrity, Privacy, and Permissions

- Follow the project's established Firebase configuration and data-access conventions.
- Do not expose credentials, tokens, passwords, private keys, or sensitive user data in source code, logs, screenshots, or error messages.
- Do not treat UI visibility as an authorization mechanism. Enforce access restrictions at the appropriate trusted data/service boundary and through Firebase security rules where applicable.
- Validate ownership and relationship permissions before performing protected operations.
- Keep records belonging to different people/profiles logically separate.
- Preserve user data and dose history when unlinking accounts unless an explicitly approved requirement states otherwise.
- Make dose confirmation and stock deduction consistent and resistant to duplicate processing where applicable.
- Do not infer that a dose was taken from a reminder dismissal, snooze, elapsed time, or app state.
- Avoid logging health information unnecessarily.
- Do not invent a database schema or security policy that conflicts with existing data or approved requirements. Inspect the current implementation first and ask before consequential changes.
- Treat offline behavior and synchronization as explicit requirements; do not claim remote data is available offline unless a supported implementation provides it.
- Do not hard-code unresolved business defaults.

## 12. Dependencies and Platform Behavior

- Inspect the existing `pubspec.yaml`, Flutter/Dart versions, project structure, and installed packages before proposing or adding dependencies.
- Prefer existing suitable dependencies over adding duplicates.
- Add a package only when it is needed for the requested functionality, compatible with the project, and justified.
- Do not upgrade, remove, or replace packages unrelated to the task.
- Explain and request approval before a dependency or platform change that is substantial, risky, breaking, or outside the requested scope.
- For Android/iOS permissions, background execution, exact alarms, notifications, audio, and restart recovery, respect real platform constraints.
- Never promise a platform behavior that has not been verified. If the requested behavior may be restricted by the OS or requires a trade-off, explain it and ask before changing the intended experience.

## 13. Existing Code and Change Safety

Before editing:
1. Inspect the relevant files and existing conventions.
2. Identify the current behavior and dependencies.
3. Determine the smallest set of changes needed for the task.
4. Check whether the task affects shared code or other features.

During editing:
- Modify only files relevant to the task and its necessary integration.
- Preserve existing code and behavior outside the approved scope.
- Do not overwrite user work, remove files, or perform destructive operations without explicit approval.
- Do not make broad automated rewrites or unrelated formatting changes.
- If a required change has wider impact than expected, stop and explain the impact before proceeding.

After editing:
- Review the diff for unintended changes.
- Summarize files changed and the purpose of each change.
- Identify any assumptions, limitations, or remaining work honestly.

## 14. Required Workflow for Every Task

For every task supplied by the project owner, follow this workflow:

1. **Read this document in full.**
2. Read the current task instructions and inspect all referenced UI/design files.
3. Inspect the relevant existing code before making changes.
4. Identify the exact scope, dependencies, acceptance criteria, and likely affected files.
5. Detect missing information or conflicts. Ask questions before implementing any ambiguous or consequential decision.
6. Provide a concise implementation plan before substantial work. Do not begin a large implementation before the plan is approved if approval was requested or the task is materially ambiguous.
7. Implement only the approved scope, following all rules in this document.
8. Run relevant formatting, static analysis, and tests that are available and appropriate.
9. Inspect the final diff and compare the UI against its approved reference.
10. Report the outcome accurately, including checks run, actual results, files changed, and known limitations.

Do not claim that code compiles, tests pass, a feature works, or a UI matches the reference unless the relevant check was actually performed. Clearly distinguish checks that passed, failed, were blocked, or were not run.

## 15. Completion Criteria

A task is complete only when:
- The requested scope is implemented and no unauthorized features have been added.
- The implementation follows the architecture, BLoC, coding, and UI rules in this document.
- Relevant error and edge cases defined by the task are handled.
- Appropriate analysis and tests have been run, with results reported honestly.
- No known unrelated or accidental changes remain.
- Any unresolved requirement or limitation is explicitly reported rather than hidden.

If any completion criterion cannot be met, explain why and identify what remains. Never label incomplete or unverified work as fully complete.

## 16. Final Non-Negotiable Rules

1. This document must be read before every task.
2. The current task defines the requested deliverable; do not implement beyond it.
3. Approved UI references must be followed accurately and consistently.
4. Never guess when a required functional or design decision is unclear; ask the project owner.
5. Never change approved product decisions without explicit approval.
6. Clean Architecture, Clean Code, SOLID, and BLoC are mandatory engineering constraints.
7. Avoid overengineering, unnecessary dependencies, speculative features, and unrelated refactoring.
8. Protect existing code and data.
9. Verify work honestly; never fabricate test results or claim unverified success.
10. If instructions conflict or a required decision is unresolved, stop the affected work and ask.

These rules apply to every task, feature, and implementation stage unless the project owner explicitly approves a change to this document.
