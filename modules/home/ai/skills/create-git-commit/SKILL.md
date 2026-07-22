---
name: create-git-commit
description: Draft and create git commits that preserve task and requirements context.
---

Use this skill when the user wants help drafting or creating a git commit after implementation work is complete.

A good commit message answers three questions for the next reader: why this change was needed now, what approach was chosen, and what the change enables or leaves for later. The rest of this skill is organized around four concerns that shape a commit message and one section on workflow.

- **Context** — where to gather information from before writing.
- **Content** — what to include and what to leave out.
- **Structure** — how the title, body, and footer are formatted.
- **Tone** — how the prose should read.
- **Workflow** — how to execute the commit itself.

A **Final Self-Check** at the end mirrors these sections so the last pass is easy to run.

## Context

Gather information from two places before writing.

### Planning artifacts

Start with the planning docs when they exist:

- `./stevies/REQs.md`
- `./stevies/TODO.md`

Use them to understand:

- the original problem
- the intended scope
- completed tasks and validations
- constraints or tradeoffs that should influence the commit message

Do not simply restate these documents. Distill the context into the commit message. Do not include them as commit contents unless the user explicitly asks.

### Git state

Then inspect the git state for decision-relevant details the planning docs may not capture:

- `git status --short`
- `git diff --staged` when staged changes exist
- `git diff` when unstaged context matters
- `git log -5 --oneline` to match local commit style

The diff and log often reveal incidental decisions (naming choices, structural tradeoffs, scope boundaries) that are worth surfacing in the commit message even when the planning docs don't mention them.

### Clarifying questions

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

Do not invent motivation, ticket IDs, ticket URLs, tradeoffs, or future plans when they are not visible in the gathered context.

## Content

Structure the commit body around three concerns:

- *Context:* why this change is needed now
- *Decision:* what approach was chosen and why
- *Consequence:* what this enables, constrains, or intentionally leaves for later

### Drafting process

1. Read the diff and planning docs. Privately identify the change type, intent, constraints, and any visible tradeoffs.
2. Draft the message around motivation, decision, and consequence.
3. Subtract anything `git show` would already make obvious (file names, helper names, moved code, renamed variables, test file additions) unless a specific location is central to the decision.

### Filtering

Keep a sentence only if it answers at least one of:

- Why was this change needed now?
- Why was this approach chosen over an obvious alternative?
- What constraint, tradeoff, or temporary limitation shaped the implementation?
- What behavior, workflow, or future work does this enable?

Remove anything a reviewer would assume was done or that has no lasting significance: test results, code formatting, build status, routine refactoring that doesn't change behavior.

The final body should still be useful when the reader already has the diff open.

### Weak vs. strong content

Weak, because it repeats the diff:

```text
Update worker prompt handling, add task ownership instructions, and adjust commit workflow guidance.
```

Strong, because it records the decision and consequence in plain words:

```text
Make worker execution deterministic by keeping task ownership explicit
in the prompt instead of relying on runtime inference. This removes
coordination drift between parallel agents. Broader workflow
automation is a separate follow-up.
```

Weak, because it lists implementation mechanics:

```text
Rename scratch queue fields, update references, and add tests for the new field names.
```

Strong, because it explains the reason for the shape of the change in the codebase's own vocabulary:

```text
Standardize scratch queue naming around the runtime model so tooling
and worker prompts use the same words. Keeping the rename narrow
avoids mixing terminology cleanup with behavior changes, which makes
the follow-up automation work easier to review.
```

## Structure

Use this format when preparing the final commit message:

```text
[TICKET-KEY] Imperative title

<1-3 short paragraphs, more when the change genuinely needs the room>

ticket: <ticket-url>
```

Omit the ticket prefix and footer when no ticket information is available or expected by the repository style.

### Title

- Use imperative mood.
- Capitalization should be natural and consistent with the repo's style.
- Keep the title concise. Target about 52 characters when practical and stay under 80 when needed.
- Do not end the title with a period.
- When a ticket key is available, prefix the title with `[TICKET-KEY]`.

### Body

- Aim for 1-3 concise paragraphs. Expand past three only when the change touches multiple collaborating concepts, or has a significant tradeoff or follow-up that a reviewer needs to understand. When in doubt, ship the shorter version.
- Hard-wrap body text at 72 characters or fewer per line. This limit applies to the body only, not the title or footer.
- Preserve paragraph breaks while wrapping. Do not insert blank lines merely because a paragraph was wrapped.
- Write for two audiences: the reviewer today and the engineer reading history months later.
- Apply the Content rules above. Keep "what changed" minimal unless it helps explain a decision.

### Footer

- When a ticket URL is provided, include `ticket: <ticket-url>`.
- If no ticket URL is provided, ask only when repo history consistently uses ticket footers, a ticket key or URL is visible in the context, or the user requested ticket metadata.
- Otherwise omit the footer.
- Never invent or transform a ticket URL.
- If a ticket key is plainly available from the provided URL, use that key in the title.

### Referencing related work

The primary ticket for this commit always uses a ticket reference. That's the "why are we here" link. Any work mentioned as context (scaffolding, prior work, related patterns, or follow-ups) should use the corresponding short commit hash instead.

Rationale: most git servers auto-convert commit hashes (e.g., `abc1234`) to clickable links, and a hash is a stable, immutable reference to the actual implementation. Use ticket references only when no commit hash is available.

### Code references

Wrap every identifier that appears in the codebase in backticks so it renders as inline code. This includes function and method names (`Notifier::send`), types (`MessageQueue`), file paths (`worker.cpp`, `config.yaml`), configuration keys (`status: ready`), event names (`user.created`), CLI flags (`--check`), and any similar reference a reader could grep for.

The test is whether the token would exist as-is in the repository. If yes, backtick it. Plain English words that happen to sound technical (queue, producer, subscriber, publish, wire format) stay unquoted unless they are literally the name of something in the code.

## Tone

Write the commit as if you are talking to a coworker who is about to pick up this code. The goal is to lower the bar to entry for the next person who reads it, not to sound authoritative or thorough. Detailed and approachable are the same thing here.

### Sentence structure

Prefer two short sentences over one long sentence.

- Do not use em-dashes (`—`) as sentence joiners.
- Do not use semicolons (`;`) as sentence joiners.
- Parentheses are allowed for genuine asides, used sparingly. If a parenthetical carries information the reader needs, promote it to its own sentence instead.

When drafting a sentence, if it would naturally want an em-dash or semicolon in the middle, that is a signal to split it into two sentences.

### Technical vocabulary

The vocabulary bar is "words a competent engineer new to this codebase would recognize," not "words that would fit in a design document."

- Use the codebase's own vocabulary freely. Names of components, types, events, and workflows are the shared language. `MessageQueue`, `Notifier`, `producer`, `subscriber`, `ticket`, `hook` are all fair game when they already exist in the code or team's vocabulary.
- Avoid vocabulary imported from outside the codebase to add authority. Phrases like "single fan-out point," "documented destruction path," "the seam that lets X collapse onto Y," "ADR-lite record," or "the durable half of this PR" are the tell. They sound sophisticated but do not help the reader understand the change any better than plainer wording would.
- The gut check: if the phrase would not naturally come out while explaining the change to a teammate at their desk, rewrite it in plainer words. Detailed does not mean elaborate.

### Weak vs. strong tone

Weak, because it reaches for a sophisticated framing:

```text
Route both events through MessageQueue::publish so Worker becomes a
queue producer like every other component, aligning it with the
single-fan-out model the rest of the system has already adopted.
```

Strong, because it says the same thing in plainer language and backticks the code:

```text
Route both events through `MessageQueue::publish` so `Worker` uses
the message queue like every other component. The rest of the system
already publishes this way.
```

Weak, because it uses em-dashes as sentence joiners and imports outside vocabulary:

```text
The message queue is becoming the single fan-out point for structured
events — producers publish once, and subscribers pick events up from
the queue rather than being called directly.
```

Strong, because it splits into short sentences and stays in the codebase's own words:

```text
The message queue is becoming the one place structured events are
published. Producers publish once. Subscribers (`Notifier`, `Worker`,
future consumers) pick events up from the queue instead of being
called directly.
```

## Workflow

Rules for executing the commit itself, separate from the message content.

### Scope of this skill

- Focus on commit creation and commit-message quality.
- Do not modify source code or planning docs as part of this skill.
- Only create or amend commits when the user explicitly asks.
- Use git history and diff context, but do not rewrite history unless the user explicitly asks for amend and it is safe to do so.

### Empty diff handling

- If nothing is staged and the user asked for a commit, say clearly that there is nothing staged to commit.
- If there are unstaged changes but nothing staged, ask whether the user wants to stage relevant files first.
- Do not create an empty commit unless the user explicitly requests one.

### Commit execution

- If the user asks only for a draft, provide the message without committing.
- If the user asks to create the commit, stage only the relevant files.
- When the relevance of specific files is ambiguous, ask which files to include rather than guessing.
- Exclude planning artifacts by default unless explicitly requested.
- After committing, report the resulting commit hash and subject.
- If hooks fail, report the failure and do not rewrite history to hide it.

## Final Self-Check

Before proposing or creating the commit, verify each section.

**Content**

- The title says what decision the commit makes, not just which files changed.
- The body would still help if the diff were already open.
- Every body sentence explains context, decision, tradeoff, consequence, or intentional follow-up.
- Any future work mentioned is grounded in the diff, task context, or user-provided plan.
- Nothing in the body is routine hygiene (tests passing, formatting, builds) that has no lasting significance.

**Structure**

- Every body line is 72 characters or fewer. The title is not wrapped as part of this check.
- The title uses imperative mood and (when applicable) the `[TICKET-KEY]` prefix.
- Ticket footer is present only when a real ticket URL is available.
- Every codebase identifier (function, type, file, event name, config key, CLI flag) is wrapped in backticks.

**Tone**

- No em-dashes or semicolons are used as sentence joiners. Long sentences are split into shorter ones.
- No vocabulary is reaching for sophistication. If a phrase would not naturally come out while explaining the change to a teammate, it has been rewritten in plainer words.

A strong commit message should still help someone months later understand why this was done now, why this approach was chosen, and why the code is shaped this way. It should complement the diff, not duplicate it.
