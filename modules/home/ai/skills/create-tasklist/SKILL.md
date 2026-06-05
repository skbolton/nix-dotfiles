---
name: create-tasklist
description: Create an execution-ready markdown task list with nested checkboxes for one-task-at-a-time agent workflows.
---

Use this skill when you need to turn reviewed requirements into a task list that an orchestrator can execute one checkbox at a time.

## Goal

Produce a markdown checklist where the first unchecked leaf task is actionable and later tasks follow in a sensible dependency order.

## Rules

- Use markdown checkboxes only.
- Use nesting to group related work when it improves readability.
- Make leaf tasks atomic, actionable, and independently completable.
- Order tasks by dependency and execution flow.
- Include validation work when appropriate.
- Do not include speculative tasks that are not grounded in the requirements or codebase.
- If the user specifies an output path or filename, write the task list there.
- When the user asks for the task list in `TODO.md`, treat that as the canonical output path for this planning workflow. File should be named `TODO.md` (all uppercase).

## Required Shape

Use this structure unless the work clearly needs a different grouping:

```md
# Task List

- [ ] Parent task
  - [ ] First actionable child task

    **File:** `lib/orders/recalculate.ex`

    Follow the existing pattern in `Payments.capture/1` — match on struct,
    delegate to the calculator, return `{:ok, result} | {:error, reason}`.

    ```elixir
    def recalculate(%Order{status: :partial_refund} = order) do
      # call RefundCalculator.run(order)
      # wrap result in ok/error tuple
    end
    ```

    **Constraint:** Do not call PaymentGateway directly — use the `Payments` context.

  - [ ] Second actionable child task
- [ ] Validation
  - [ ] Run targeted tests
  - [ ] Manual verification steps
- [ ] Post-approval cleanup
  - [ ] Strip transition verification tests before commit
```

Not every task needs nested context. Simple, self-explanatory tasks (e.g., "Run the test suite", "Update module doc") should remain concise.

## Task Design Guidance

### Parent Checkboxes

- Use parent items to group related implementation areas.
- A parent checkbox should usually not be directly executable if it has children.
- Parent items should summarize the purpose of the child tasks.

### Leaf Checkboxes

- Each leaf item should represent one unit of work for `worker`.
- A leaf task should be narrow enough to complete in one pass, but broad enough to handle small local issues.
- Use clear action verbs like `Add`, `Update`, `Refactor`, `Wire`, `Validate`, or `Document`.
- Tasks that require the user to run, build, launch, interact with, or observe a live application instance should be prefixed with `**MANUAL (User):**`. These are not worker-executable. Tasks that are purely user decision or capture moments should use `**MANUAL CHECKPOINT:**`.
- The first actionable unchecked checkbox should always be worker-executable. Do not allow the first unchecked leaf to be a user-facing or manual-only task unless all worker tasks upstream of it are complete.

### Nested Implementation Context

Leaf tasks can include nested context below the checkbox line to guide the executor. Use indented prose under the checkbox, separated by a blank line from the checkbox text.

Context blocks may include any combination of:

- **File paths** to create or modify.
- **The "why"** — what this task accomplishes in the larger feature.
- **Code shape** — a short snippet showing the expected pattern, signature, or structure. Do not write the full implementation; show enough that the executor knows what pattern to follow.
- **Constraints** — things the executor must not do, or boundaries they should stay within.
- **Discovery hints** — what to look at or search for if the task requires orientation before action.

When to include nested context:

- The task involves non-obvious wiring, unfamiliar patterns, or cross-module coordination.
- There is an existing pattern elsewhere in the codebase that the task should follow.
- The task has constraints that are not obvious from the checkbox text alone.
- Architectural decisions have already been made that the executor should not re-derive.

When to omit it:

- The checkbox text is self-explanatory (e.g., "Run `mix test`", "Delete unused import").
- The task is purely mechanical and the executor can find the right approach from the checkbox text alone.

Nested context is encouraged but not required at task-list creation time. The orchestrator may enrich context just before delegation once earlier tasks have landed and the codebase state is clearer.

### Ordering

- Put prerequisites before dependents.
- Prefer the smallest viable next step first.
- Avoid forcing the executor to decide between multiple equally valid first steps.

### Validation

- Add explicit validation tasks when tests, builds, manual verification, or rollout checks are needed.
- Keep validation near the work it verifies or in a final validation section when that is clearer.
- When writing tests as part of validation, apply the **test classification** guidance from the `create-requirements` skill: only write tests that represent permanent behavior contracts. Transition verification tests and regression guard tests for the old flag-off path are valuable during development and review — retain them as scaffolding with clear comments marking them as such, so the reviewer can see what was verified. They are **not committed** but they are kept in the code during review.

### Post-Approval Cleanup

- Add a final `Post-approval cleanup` section with one task: **Strip transition verification tests before commit**.
- This step is triggered **after the reviewer gives final sign-off**, not executed autonomously by the lead agent.
- It should be the last checkbox in the list, representing the gate between "approved" and "ready to commit".
- The lead agent does not check this box itself — it is explicitly triggered by the user when they say "looks good, let's get this ready to commit."

## Output Standard

- The list must work for a `lead` agent that selects the first unchecked leaf checkbox.
- A task with nested context should be self-contained enough that a mid-level engineer with codebase access but no prior feature context could complete it without making architectural decisions.
- Avoid ambiguous items like `handle edge cases` unless the specific edge cases are already known.
- If a task depends on unresolved requirements, represent that as its own checkbox or leave it out and note it separately.
- If the user provided a save location, persist the task list there instead of only pasting it in chat.
- If no save location was provided, draft the content in chat and ask one targeted question about where to save it.
