We have completed the planning phase, and the decisions are finalized.

I was in Plan Mode, so the revised plan may exist only in the conversation and may not have been saved to disk.

Now switch to implementation mode and proceed as follows:

1. Read `AGENTS.md`, `PROMPT_PHASE_1_PLAN.md`, and the `ui_phase_1/` references.
2. Use the revised plan and all approved decisions from this conversation as the source of truth.
3. Create `PHASE_1_APPROVED_PLAN.md` in the project root to preserve the final decisions. Do not create `PROMPT_PHASE_1_IMPLEMENTATION.md`.
4. After saving and checking the approved plan, immediately start implementing Phase 1. Do not stop after creating the document, return to planning, or ask me to approve the same decisions again.
5. Follow the agreed implementation order and all constraints. Ask me only when a genuine blocker requires my input.

Start by checking the current project state, then create the document and begin implementation. Report actual changes and verification results as you progress.

## 6. Implementation Progress Tracking

Create and maintain `IMPLEMENTATION_STATUS.md` in the project root. This file is mandatory and must reflect the actual implementation state at all times.

After each meaningful implementation step, update the file with:

- **Current phase and step:** Identify exactly which implementation step is in progress.
- **Completed work:** List the features and tasks actually completed.
- **Changed files:** Identify important files created, modified, or deleted.
- **Work in progress:** Describe any partially implemented task and the last known stopping point.
- **Remaining work:** List the next tasks in the approved implementation order.
- **Verification results:** Record the commands actually executed and their real outcomes, including tests, analysis, and build checks where applicable.
- **Known issues and blockers:** Record errors, incomplete integrations, and unresolved decisions.
- **Next action:** Specify the exact next task that should be performed.

Do not mark a task as completed merely because it was planned, discussed, or partially implemented. Only mark it complete when the actual code and available verification support that status.

Do not fabricate test results, successful commands, or implementation progress. Clearly distinguish between checks that passed, failed, or have not yet been run.

If implementation is interrupted, document the last known state, unfinished work, relevant errors, and the safest next step as soon as possible.

## 7. Preserve the Approved Plan

`PHASE_1_APPROVED_PLAN.md` is the authoritative source for the approved requirements, architecture, UI references, implementation order, and constraints.

`IMPLEMENTATION_STATUS.md` records progress only. Do not use it to silently change approved requirements or architectural decisions.

Do not create `PROMPT_PHASE_1_IMPLEMENTATION.md`.

Do not discard existing work, overwrite unrelated files, or revert changes simply to make the project match the documentation. If the actual code and documentation disagree, investigate the discrepancy before changing anything.

## 8. Safe Model and Session Handoffs

The implementation must remain resumable if I change models, reach a usage limit, or start a new session.

When continuing with another model or session, the first steps must be:

1. Read `AGENTS.md`.
2. Read `PHASE_1_APPROVED_PLAN.md`.
3. Read `IMPLEMENTATION_STATUS.md`.
4. Review the relevant references in `ui_phase_1/`.
5. Inspect the actual repository state, including modified files and incomplete changes.
6. Compare the actual code with the progress file and correct any inaccurate status information.
7. Identify the first genuinely incomplete task and resume from that point.

Never assume that a task was completed simply because the previous model claimed it was completed. Verify the repository state before proceeding.

Do not restart the project from scratch, repeat completed work unnecessarily, or discard existing changes. Preserve all approved requirements and continue in the agreed implementation order.

If the previous session stopped before updating the progress file, reconstruct the actual state by inspecting the code and available verification results before updating the status and continuing.

## 9. Verification and Reporting

After each meaningful implementation step:

- Run the relevant verification checks when possible.
- Resolve errors introduced by the implementation before proceeding, unless a genuine blocker prevents this.
- Update `IMPLEMENTATION_STATUS.md` with the actual results.
- Briefly report what changed, what was verified, what remains, and what comes next.

Do not claim that the entire phase is complete until all required tasks have been implemented and the applicable verification checks have been performed.

Begin by inspecting the current project state. Then create and verify `PHASE_1_APPROVED_PLAN.md`, initialize `IMPLEMENTATION_STATUS.md`, and immediately continue with Phase 1 implementation without requesting redundant approval.
