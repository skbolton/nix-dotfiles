---
name: create-pull-request
description: Create a pull request with a structured description derived from the branch commits and a reviewer-guided file tour.
---

Use this skill when the user wants to create a pull request after committing their work.

## Goal

Produce a pull request whose description gives the reviewer full context from the commit history and a guided tour of the changed files in an order that builds understanding incrementally.

## Rules

- Do not modify source code, planning docs, or git history as part of this skill.
- Do not invent motivation, ticket IDs, ticket URLs, tradeoffs, or future plans.
- Use the branch's commit messages as the authoritative source for the PR title and the first section of the body.
- Always confirm the proposed file viewing order with the user before creating the PR.
- If the branch has not been pushed to the remote, push it before creating the PR.

## Provider

This skill is provider-agnostic. Before creating the PR, identify which source code provider hosts the repository's remote (e.g., check the `origin` URL), then read the matching reference file from the `references/` folder adjacent to this skill for provider-specific CLI commands, flags, and formatting notes.

If no matching provider reference exists, ask the user how they would like the PR created.

## Inputs To Inspect

Gather context from the branch relative to the base branch:

- `git log --format='%s%n%n%b' <base-branch>..HEAD` — all commit subjects and bodies on the branch
- `git diff --name-only <base-branch>..HEAD` — all changed files on the branch
- `git diff <base-branch>..HEAD` — the full diff for understanding file relationships

Detect the default base branch by running `git default-branch`.

## PR Title

Use the most recent commit's subject line as the PR title. This preserves any ticket prefix (e.g., `[TICKET-KEY]`) that the repository requires.

## PR Description Structure

```markdown
<commit body content>

---

## For reviewers

Recommended file viewing order:

1. [path/to/first-file](changes#diff-<hash>) — <one-line reason why to read this first>
2. [path/to/second-file](changes#diff-<hash>) — <one-line reason>
3. [path/to/third-file](changes#diff-<hash>) — <one-line reason>
...
```

File entries should be clickable links that jump the reviewer directly to that file's diff in the PR. The link format is provider-specific — consult the provider reference for how to construct these anchors.

### Above the separator

Place the commit message content as-is. This includes the motivation, decision, consequence paragraphs, and any ticket footer. Do not rewrite, summarize, or editorialize — the commit messages were already crafted with care.

When the branch has a single commit, use its body directly.

When the branch has multiple commits, prefer the most recent commit's body if it already captures the full context (common when the user writes a final summary commit). If earlier commits contain distinct context not covered by the most recent, concatenate their bodies chronologically and confirm the draft with the user. If concatenation produces a cluttered result, distill the combined messages into the same context/decision/consequence structure used by the `create-git-commit` skill and confirm with the user.

### Below the separator

The `## For reviewers` section contains information that helps during review but does not belong in permanent git history.

#### Recommended file viewing order

Produce a numbered list of changed files in the order a reviewer should read them to build understanding incrementally.

**Ordering strategy:**

1. Start with files that introduce new concepts, types, or interfaces that other files depend on.
2. Follow with core implementation files that use those concepts.
3. Then supporting changes (config, wiring, glue code).
4. End with tests, docs, or other verification files.

Within each tier, prefer the file that has fewer dependencies on other changed files. The goal is that by the time the reviewer reaches file N, they have already seen everything file N depends on.

**Annotation:**

Each entry gets a short (under 15 words) annotation explaining why it is at that position. Focus on what understanding it provides for later files.

**Exclusions:**

- Omit lockfiles, generated files, and purely mechanical changes (e.g., auto-formatter diffs) unless they are central to the PR's purpose.
- If the PR touches more than ~20 files, group related files and annotate the group rather than listing each individually.

## Workflow

1. Identify the source code provider and read the matching provider reference from the `references/` folder.
2. Run `git default-branch` to detect the repository's default branch.
3. Ask the user which branch the PR should target. Present the default branch as the most likely option but let the user specify a different one.
4. Read the branch's commit messages and diff relative to the confirmed base branch.
5. Analyze file dependencies and draft the recommended viewing order.
6. Present the proposed PR to the user:
   - Show the PR title.
   - Show the base branch the PR targets.
   - Show the full description (commit body content + separator + viewing order).
   - Ask the user to confirm or adjust the file viewing order.
7. Wait for user confirmation. Do not create the PR until the user approves.
8. Ensure the branch is pushed to the remote.
9. Create the PR using the provider-specific commands from the reference, targeting the confirmed base branch.
10. Report the resulting PR URL to the user.

## Clarifying Questions

Ask before proceeding when:

- The base branch is ambiguous (e.g., multiple long-lived branches exist).
- The commit messages are empty and the PR would lack meaningful description.
- Multiple commits exist and it is unclear whether to use the most recent body or concatenate.
- The user may want to add reviewers, labels, or draft status.
- No provider reference matches the repository remote.

## Example

Given a branch with one commit:

```text
[PROJ-142] Extract payment retry logic into dedicated service

The retry logic was embedded in three different controller actions with
subtle behavioral differences. Centralizing it removes the drift risk and
makes the upcoming webhook retry work possible without touching controllers
again.

Intentionally leaves the old controller methods as thin wrappers that
delegate to the new service — removing them is a separate cleanup once
downstream consumers migrate.

ticket: https://jira.example.com/browse/PROJ-142
```

The resulting PR:

**Title:** `[PROJ-142] Extract payment retry logic into dedicated service`

**Body:**
```markdown
The retry logic was embedded in three different controller actions with
subtle behavioral differences. Centralizing it removes the drift risk and
makes the upcoming webhook retry work possible without touching controllers
again.

Intentionally leaves the old controller methods as thin wrappers that
delegate to the new service — removing them is a separate cleanup once
downstream consumers migrate.

ticket: https://jira.example.com/browse/PROJ-142

---

## For reviewers

Recommended file viewing order:

1. [`lib/payments/retry_service.ex`](changes#diff-abc123) — new module; defines the interface everything else delegates to
2. [`lib/payments/retry_policy.ex`](changes#diff-def456) — retry policy rules consumed by the service
3. [`lib/payments/payments.ex`](changes#diff-789abc) — context module wiring that exposes the new service
4. [`lib/web/controllers/charge_controller.ex`](changes#diff-aaa111) — controller now delegates to service
5. [`lib/web/controllers/subscription_controller.ex`](changes#diff-bbb222) — same delegation pattern
6. [`lib/web/controllers/invoice_controller.ex`](changes#diff-ccc333) — same delegation pattern
7. [`test/payments/retry_service_test.exs`](changes#diff-ddd444) — verifies the new service behavior
```

## Final Self-Check

Before presenting the PR draft to the user, verify:

- The title matches the most recent commit subject exactly.
- The body above the separator is unmodified commit message content.
- The viewing order follows a dependency-first strategy, not alphabetical or diff order.
- Each annotation explains what understanding the file provides, not what it does mechanically.
- No information has been invented beyond what the diff and commit messages support.
- The PR is not created until the user has confirmed the viewing order.
