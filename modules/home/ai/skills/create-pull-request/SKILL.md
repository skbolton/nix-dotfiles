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

### Recommended file viewing order:

1. [path/to/first-file](<pr-url>/changes#diff-<hash>)
   - <short reason this file appears here>
2. [path/to/second-file](<pr-url>/changes#diff-<hash>) / [path/to/companion-file](<pr-url>/changes#diff-<hash>)
   - <short reason>
   - <optional second bullet for a distinct constraint>
3. [path/to/third-file](<pr-url>/changes#diff-<hash>)
...
```

File entries should be clickable links that jump the reviewer directly to that file's diff in the PR. The link format is provider-specific and may require a two-step flow (create PR, then patch links) — consult the provider reference for details.

Tightly-coupled files (e.g., a header and its implementation, or two parallel modules that share a single rationale) may share one numbered entry separated by ` / `, with reasons in shared bullets below.

### Above the separator

Place the commit message content as the body, with one transformation: unwrap single-newline line breaks into spaces, but preserve blank lines between paragraphs.

Commit messages are typically hard-wrapped at 72–80 columns for git tooling, but PR descriptions render in a wide browser column. Passing the message through verbatim produces awkward early line breaks mid-sentence. Treating two-or-more consecutive newlines as paragraph breaks (matching markdown's own paragraph rules) and collapsing single newlines to spaces yields paragraphs that flow naturally in the rendered PR.

Do not otherwise rewrite, summarize, or editorialize — the commit messages were already crafted with care. Preserve the motivation, decision, and consequence paragraphs and any ticket footer exactly.

When the branch has a single commit, use its body directly (with the unwrap transformation above).

When the branch has multiple commits, prefer the most recent commit's body if it already captures the full context (common when the user writes a final summary commit). If earlier commits contain distinct context not covered by the most recent, concatenate their bodies chronologically and confirm the draft with the user. If concatenation produces a cluttered result, distill the combined messages into the same context/decision/consequence structure used by the `create-git-commit` skill and confirm with the user.

### Below the separator

The `## For reviewers` section contains information that helps during review but does not belong in permanent git history.

#### Recommended file viewing order

Produce a numbered list of the pivotal files a reviewer needs to read to understand the change, in the order that builds understanding incrementally.

This is a guided tour, not an inventory. Completeness is not the goal — signal is. A file earns a slot in the order only if reading it changes the reviewer's understanding of the PR. Files that don't drive a decision, expose a contract, or carry meaningful logic should be omitted, not included for the sake of accounting for every diff.

**Ordering strategy:**

For the files that do appear:

1. Start with files that introduce new concepts, types, or interfaces that other files depend on.
2. Follow with core implementation files that use those concepts.
3. Then supporting changes (config, wiring, glue code).
4. End with tests, docs, or other verification files when they meaningfully reinforce the change.

Within each tier, prefer the file that has fewer dependencies on other changed files. The goal is that by the time the reviewer reaches file N, they have already seen everything file N depends on.

**Annotation:**

Each entry gets zero, one, or two short bullets (under 15 words each) explaining why the file appears at this position. Focus on what understanding it provides for *later* files in the order, not what the file does mechanically.

- **Zero bullets** when the file is self-explanatory once the position is known. The trailing test file in a feature PR rarely needs a bullet — its slot at the end of the order tells the reviewer it verifies everything above it.
- **One bullet** is the common case. State the one thing the reviewer should know before opening the diff.
- **Two bullets** only when there is a distinct constraint or non-obvious choice worth flagging *in addition to* the primary reason — never to elaborate on the first bullet.

Three or more bullets is a smell: the file probably needs an inline code comment or a richer commit message rather than PR-description framing.

**Exclusions:**

The criterion for omission is signal, not file type. Apply judgment based on the specific PR — a docs-only PR legitimately centers on a README, and a test file can be pivotal when it defines the contract being introduced. In a typical PR, however, the following commonly fall below the signal threshold and should be omitted:

- Lockfiles, generated files, and purely mechanical changes (e.g., auto-formatter diffs) unless they are central to the PR's purpose.
- README, CHANGELOG, or comment-only edits that document the change without driving any decision discussed in the PR body.
- Test or fixture files that exist only to keep the suite green and don't demonstrate a new contract or behavior worth walking the reviewer through.
- Trivial wiring (one-line registrations, re-exports) when the file it wires to is already in the order and the wiring is obvious.

If the PR touches more than ~20 files after applying these exclusions, group related files and annotate the group rather than listing each individually.

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
10. If the provider requires a two-step flow for diff links (e.g., GitHub needs the PR URL to construct full links), capture the PR URL and immediately edit the body to inject the final links.
11. Report the resulting PR URL to the user.

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

The retry logic was embedded in three different controller actions
with subtle behavioral differences. Centralizing it removes the drift
risk and makes the upcoming webhook retry work possible without
touching controllers again.

Intentionally leaves the old controller methods as thin wrappers
that delegate to the new service — removing them is a separate
cleanup once downstream consumers migrate.

ticket: https://jira.example.com/browse/PROJ-142
```

The resulting PR:

**Title:** `[PROJ-142] Extract payment retry logic into dedicated service`

**Body:**
```markdown
The retry logic was embedded in three different controller actions with subtle behavioral differences. Centralizing it removes the drift risk and makes the upcoming webhook retry work possible without touching controllers again.

Intentionally leaves the old controller methods as thin wrappers that delegate to the new service — removing them is a separate cleanup once downstream consumers migrate.

ticket: https://jira.example.com/browse/PROJ-142

---

## For reviewers

Recommended file viewing order:

1. [`lib/payments/retry_service.ex`](https://github.com/owner/repo/pull/7/changes#diff-abc123)
   - new module that defines the interface everything else delegates to
2. [`lib/payments/retry_policy.ex`](https://github.com/owner/repo/pull/7/changes#diff-def456)
   - retry policy rules consumed by the service
3. [`lib/payments/payments.ex`](https://github.com/owner/repo/pull/7/changes#diff-789abc)
   - context module wiring that exposes the new service
4. [`lib/web/controllers/charge_controller.ex`](https://github.com/owner/repo/pull/7/changes#diff-aaa111) / [`lib/web/controllers/subscription_controller.ex`](https://github.com/owner/repo/pull/7/changes#diff-bbb222) / [`lib/web/controllers/invoice_controller.ex`](https://github.com/owner/repo/pull/7/changes#diff-ccc333)
   - all three controllers move to the same delegation pattern; read once, the others mirror it
5. [`test/payments/retry_service_test.exs`](https://github.com/owner/repo/pull/7/changes#diff-ddd444)
```

Notice in the example above that the commit body's hard-wrapped lines have been unwrapped into flowing paragraphs, the three controllers share a single grouped entry, and the test file sits at the end with no bullet because its position alone explains its role. The PR's diff also touches `mix.lock`, a `CHANGELOG.md` entry, and a routine fixture update for the new test — none appear in the order because they don't change what the reviewer needs to understand.

## Final Self-Check

Before presenting the PR draft to the user, verify:

- The title matches the most recent commit subject exactly.
- The body above the separator preserves the commit message verbatim except for unwrapping single-newline line breaks into spaces; blank-line paragraph breaks remain intact.
- The viewing order follows a dependency-first strategy, not alphabetical or diff order.
- Every file in the order earns its slot — files that don't change the reviewer's understanding (lockfiles, routine doc/test updates, trivial wiring) are omitted, not included for completeness.
- Each file entry uses zero, one, or at most two short bullets — never three or more.
- Bullets explain what understanding the file provides for later entries, not what the file does mechanically.
- No information has been invented beyond what the diff and commit messages support.
- The PR is not created until the user has confirmed the viewing order.
