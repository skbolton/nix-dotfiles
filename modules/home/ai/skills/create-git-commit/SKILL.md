---
name: create-git-commit
description: Draft and create git commits that preserve task and requirements context.
---

Use this skill when the user wants help drafting or creating a git commit after implementation work is complete.

## Goal

Produce commit messages that capture why the change exists, what decision was made, and what the change enables, while fitting the user's preferred title and footer structure.

## Rules

- Focus on commit creation and commit-message quality.
- Do not modify source code or planning docs as part of this skill.
- Only create or amend commits when the user explicitly asks.
- Use git history and diff context, but do not rewrite history unless the user explicitly asks for amend and it is safe to do so.
- Do not invent motivation, ticket IDs, ticket URLs, tradeoffs, or future plans.
- If the intent behind the change is unclear, ask targeted questions before finalizing the message.
- Treat planning artifacts such as `requirements.md` and `TODO.md` as context sources by default, not commit contents.
- Do not include `requirements.md`, `TODO.md`, or similar planning files in the commit unless the user explicitly asks to include them.

## Inputs To Inspect

Inspect the smallest useful set of inputs for the request:

- `git status --short`
- `git diff --staged` when staged changes exist
- `git diff` when unstaged context matters
- `git log -5 --oneline` to match local commit style

When present and relevant to the work, also inspect:

- `requirements.md`
- `TODO.md`

Use those documents to understand:

- the original problem
- the intended scope
- completed tasks and validations
- constraints or tradeoffs that should influence the commit message

Do not simply restate those documents. Distill the context into the commit message.

## Commit Framing

Treat the final commit message as an ADR-lite record:

- Context: why this change is needed now
- Decision: what approach was chosen and why
- Consequence: what this enables, constrains, or intentionally leaves for later

Assume future readers can inspect the diff. Favor motivation and reasoning over file-by-file narration.

## Message Value Filter

Before finalizing the commit message, remove any sentence whose only value is summarizing the diff. Future readers can inspect changed files themselves.

Keep a sentence only if it answers at least one of:

- Why was this change needed now?
- Why was this approach chosen over an obvious alternative?
- What constraint, tradeoff, or temporary limitation shaped the implementation?
- What behavior, workflow, or future work does this enable?

Omit anything a reviewer would assume was done, or that has no lasting significance: test results, code formatting, build status, or routine refactoring that doesn't change behavior.

Avoid file-by-file or function-by-function narration unless the specific code location is central to the decision.

## Diff-Subtractive Workflow

Use the diff to understand what changed, then subtract details that `git show` would already make obvious.

- First, privately identify the change type, intent, constraints, and any visible tradeoffs.
- Then, draft the message around the motivation, decision, and consequence.
- Finally, delete mechanical details such as file names, helper names, moved code, renamed variables, and test file additions unless they explain why the approach matters.

The final body should still be useful when the reader already has the diff open.

## Clarifying Questions

Ask before proceeding when any of the following are unclear:

- the problem being solved
- whether the change is a feature, fix, refactor, or test/supporting work
- which changes are intentional versus incidental
- the tradeoff or reason for the chosen approach
- whether unusual code is temporary, a workaround, or an intentional constraint

Use specific questions like:

- "What problem were you solving with this change?"
- "Is this addressing a bug, a refactor, or a new behavior change?"
- "Is this approach intentional long-term, or should the commit note a temporary workaround?"

## Message Structure

Use this format when preparing the final commit message:

```text
[TICKET-KEY] Imperative title

<1-3 short paragraphs>

ticket: <ticket-url>
```

Omit the ticket prefix and footer when no ticket information is available or expected by the repository style.

### Title Rules

- Use imperative mood.
- Capitalization should be natural and consistent with the repo's style.
- Keep the title concise; target about 52 characters when practical and stay under 80 when needed.
- Do not end the title with a period.
- When a ticket key is available, prefix the title with `[TICKET-KEY]`.

### Body Rules

- Use 1-3 concise paragraphs.
- Write for two audiences: the reviewer today and the engineer reading history months later.
- Only include what matters to those readers: the motivation, the decision, and why it matters now and in the future.
- Omit anything a reviewer would assume was done, or that has no lasting significance: test results, code formatting, build status, routine refactoring that doesn't change behavior.
- Keep "what changed" minimal unless it helps explain a decision.
- Draft mechanically if useful, then remove details that merely name files, functions, helpers, or operations already visible in the diff.

### Footer Rules

- When a ticket URL is provided, include `ticket: <ticket-url>`.
- If no ticket URL is provided, ask only when repo history consistently uses ticket footers, a ticket key or URL is visible in the context, or the user requested ticket metadata.
- Otherwise omit the footer.
- Never invent or transform a ticket URL.
- If a ticket key is plainly available from the provided URL, use that key in the title.
- *Prefer short commit hashes over ticket numbers when referencing related work.* The primary ticket for this PR always uses a ticket reference (that's the "why are we here" link). However, any ticket mentioned as context—scaffolding, prior work, related patterns, or follow-ups—should use the corresponding short commit hash instead. Most git servers auto-convert commit hashes (e.g., `abc1234`) to clickable links, which are immediately useful, and a hash is a stable, immutable reference to the actual implementation. Use ticket references only when no commit hash is available.

## Task-Oriented Workflow Guidance

When the repo workflow used `./stevies/requirements.md` and `./stevies/TODO.md`:

- Review completed tasks before writing the commit message.
- Roll meaningful implementation intent from those documents into the body.
- Prefer reasoning like "standardize scratch queue naming so tooling and runtime consumers stay aligned" over a checklist of edits.

## Empty Diff Handling

- If nothing is staged and the user asked for a commit, say clearly that there is nothing staged to commit.
- If there are unstaged changes but nothing staged, ask whether the user wants to stage relevant files first.
- Do not create an empty commit unless the user explicitly requests one.

## Commit Execution Guidance

- If the user asks only for a draft, provide the message without committing.
- If the user asks to create the commit, stage only the relevant files.
- Exclude planning artifacts by default unless explicitly requested.
- After committing, report the resulting commit hash and subject.
- If hooks fail, report the failure and do not rewrite history to hide it.

## Examples

Weak, because it repeats the diff:

```text
Update worker prompt handling, add task ownership instructions, and adjust commit workflow guidance.
```

Strong, because it records the decision and consequence:

```text
Make worker execution deterministic by keeping task ownership explicit in the prompt instead of relying on runtime inference. This reduces coordination drift between parallel agents while leaving broader workflow automation as a separate follow-up.
```

Weak, because it lists implementation mechanics:

```text
Rename scratch queue fields, update references, and add tests for the new field names.
```

Strong, because it explains the reason for the shape of the change:

```text
Standardize scratch queue naming around the runtime model so tooling and worker prompts use the same vocabulary. Keeping the rename narrow avoids mixing terminology cleanup with behavior changes, making the follow-up automation work easier to review.
```

## Final Self-Check

Before proposing or creating the commit, verify:

- The title says what decision the commit makes, not just which files changed.
- The body would still help if the diff were already open.
- Every body sentence explains context, decision, tradeoff, consequence, or intentional follow-up.
- Any future work mentioned is grounded in the diff, task context, or user-provided plan.
- Nothing in the body is routine hygiene (tests passing, formatting, builds) that has no lasting significance.

## Quality Bar

A strong commit message should still help someone months later understand:

- why this was done now
- why this approach was chosen
- why the code is shaped this way

It should complement the diff, not duplicate it.
