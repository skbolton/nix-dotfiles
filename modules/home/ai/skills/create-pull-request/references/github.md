# GitHub Provider Reference

Use this reference when the repository's remote points to GitHub (e.g., `github.com` in the remote URL).

## CLI Tool

GitHub CLI (`gh`) — assumed installed and authenticated.

## Push Branch

```bash
git push -u origin HEAD
```

## Create Pull Request

```bash
gh pr create --title "<title>" --body "<body>"
```

### Optional Flags

| Flag | Purpose |
|------|---------|
| `--draft` | Mark as draft PR |
| `--reviewer <handle>` | Request review from user or team |
| `--label <name>` | Add labels |
| `--base <branch>` | Target a non-default base branch |
| `--assignee <login>` | Assign the PR |

### Body Formatting

- GitHub renders the body as markdown.
- Use a HEREDOC when passing multi-line body content to avoid shell quoting issues:

```bash
gh pr create --title "<title>" --body "$(cat <<'EOF'
<body content>
EOF
)"
```

## Verify PR Creation

`gh pr create` prints the PR URL on success. Report this URL to the user.

## File Diff Anchor Links

GitHub's PR "Files changed" tab generates anchors for each file using the SHA-256 hash of the file path. Because the PR number is not known until after creation, file links must be patched in after the PR is created.

**Anchor format:**

```markdown
[`path/to/file.ex`](<pr-url>/changes#diff-<sha256-of-path>)
```

For example, if the PR URL is `https://github.com/owner/repo/pull/42`:

```markdown
[`lib/payments/retry_service.ex`](https://github.com/owner/repo/pull/42/changes#diff-abc123...)
```

**Computing the hash:**

```bash
echo -n "path/to/file.ex" | shasum -a 256 | awk '{print $1}'
```

Or in a single pass for all changed files:

```bash
git diff --name-only $(git merge-base HEAD <base-branch>)..HEAD | while read -r f; do
  hash=$(echo -n "$f" | shasum -a 256 | awk '{print $1}')
  echo "[$f](<pr-url>/changes#diff-$hash)"
done
```

The anchor uses the full 64-character hex hash.

**Two-step creation flow:**

Because the PR URL is needed for the diff links, use this sequence:

1. Create the PR with placeholder links or without links in the guided tour.
2. Capture the PR URL from the `gh pr create` output.
3. Immediately edit the PR body to inject the full links using `gh pr edit <pr-number> --body "<updated-body>"`.

This ensures the diff links resolve correctly regardless of where the reader is on GitHub.

## Notes

- If `gh` is not authenticated, it will prompt. The agent should not attempt to authenticate on behalf of the user — report the issue and let the user resolve it.
- `gh pr create` will fail if the branch is not pushed. Always ensure the branch is pushed before attempting to create the PR.
