---
name: create-requirements
description: Create a reviewable requirements document grounded in the user request and the current codebase.
---

Use this skill when you need to turn a requested change into a concrete requirements document.

## Goal

Produce a requirements document that is explicit, reviewable, and implementation-guiding without inventing product behavior.

## Rules

- Ground the document in the user's request and the codebase.
- Do not invent scope, constraints, or acceptance criteria.
- Separate confirmed requirements from assumptions and open questions.
- Prefer concise language over long prose.
- Make the document easy for an execution agent to consume later.
- If the user specifies an output path or filename, write the requirements there.
- When the user asks for the requirements in `REQS.md`, treat that as the canonical output path for this planning workflow. File should be named `REQS.md` (all uppercase, plural).
- If the user provides a related ticket key or ticket URL, include it in the requirements document in a dedicated `## Related Ticket` section.

## Required Sections

Use this structure unless the user asks for something else:

```md
# Requirements

## Related Ticket
- <TICKET-KEY>: <TICKET-URL>

## Goal
- ...

## Scope
- In scope: ...
- Out of scope: ...

## Constraints
- ...

## Acceptance Criteria
- ...

## Implementation Notes
- ...

## Open Questions
- ...
```

## Section Guidance

### Goal

- State the user-visible or business goal.
- Keep it short and specific.

### Related Ticket

- Include this section when the user provides a ticket key or ticket URL during planning.
- Prefer the full URL when available.
- If only a ticket key is provided, include the key and omit the URL rather than inventing one.

### Scope

- Separate what must change from what should not change.
- If out-of-scope items are not known, say `- None identified yet` instead of guessing.

### Constraints

- Capture technical, product, workflow, or environment constraints supported by the request or repo.
- If none are known, say `- None identified yet`.

### Acceptance Criteria

- Write testable statements.
- Prefer observable outcomes over implementation details.
- If criteria cannot be finalized, put the uncertainty in `Open Questions` instead of pretending certainty.

### Implementation Notes

- Include repo-specific details, affected areas, dependencies, migration concerns, or validation expectations.
- Keep this informational, not prescriptive, unless the user already chose an approach.

### Test Classification

When a feature-flag implementation is involved, explicitly classify each test that will be written:

- **Permanent contract** — tests the final behavior that survives flag archival. These should be named for the behavior, not for the flag. Example: "shows a flash message when clicking during cycling" — not "flash message appears when flag is on." These are the tests that **should be committed**.

- **Transition verification** — tests the flag toggle logic (e.g., "asserts no alert in DOM when flag is on"). These verify the migration works but become meaningless once the flag is archived and the old path is deleted. These tests **should NOT be committed** — they are scaffolding, not a lasting test suite.

- **Regression guard** — tests the old path still works during migration. These protect against regressions while both code paths are live. Once the flag is archived and the old code is deleted, these tests **should be deleted, not committed**.

Concretely:
- **Test names must never reference the flag.** When the flag is archived, no test name should need editing.
- **The `with_flag` wrapper is not the determining factor.** A test written inside `with_flag` during implementation may still be a permanent contract — what matters is whether it describes the final behavior. For example, a test verifying "flash message displays when clicking during cycling" is a permanent contract even if it was wrapped in `with_flag` during development. Stripping the flag context is a cleanup step, not a reclassification.
- If a test asserts the *old* behavior (e.g., "alert element IS present"), it is a regression guard — do not commit it.
- If a test describes what the user experiences regardless of how it is implemented, commit it.

The goal is that the final test suite reads like a **specification of promises**, not a **changelog of changes**.

### Open Questions

- Include unresolved decisions, missing product details, or risky assumptions.
- If there are none, say `- None`.
- Treat this section as a **working buffer, not a log**. When a question is resolved:
  - Fold the resolution into the appropriate section — as a `Constraint`, an `Acceptance Criterion`, an `Implementation Note`, or a task-list checkbox — wherever it will actually be applied during implementation.
  - Delete the question itself from `Open Questions`.
  - If the resolution does not materially affect how the work is done, do not record it at all. Do not leave "resolved with note" entries behind.
- The goal is that a reader opening the final document sees only questions that still need answers, not a history of decisions already made.

## Output Standard

- Produce a document that `lead` can hand directly to `worker`.
- Avoid hidden assumptions.
- If information is missing, make that explicit in `Open Questions` rather than filling gaps yourself.
- If the user provided a save location, persist the document there instead of only pasting it in chat.
- If no save location was provided, draft the content in chat and ask one targeted question about where to save it.
