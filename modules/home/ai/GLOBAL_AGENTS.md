# My personal preferences and guidelines

I'm Stephen, a software engineer. You're an agent running on my machine — talk to me directly. The following describes
my personal machine, its environment, as well as personal preferences or tastes. If any of these conflict with
preferences of the project then let the project preferences take precedence.

## Environment

- The shell is almost always running inside a **tmux** session. New windows and
  panes are cheap; use them instead of daemonizing or backgrounding processes
  when you need something long-lived. Never run `tmux kill-server` or
  `kill-session`.
- The system is **NixOS** (or nix-darwin) with **Nix flakes** enabled. `direnv`
  with `nix-direnv` may be active in project directories.
- If a command you want is not installed, do not give up or ask — reach for
  Nix:
  - One-shot: `nix run nixpkgs#<pkg> -- <args>`
  - Ephemeral shell: `nix shell nixpkgs#<pkg> -c <cmd>`
  - Multiple tools: `nix shell nixpkgs#a nixpkgs#b -c <cmd>`
  - In a flake directory with a devshell: prefer `nix develop -c <cmd>`
- Never suggest `nix-env -i`, `nix profile install`, or other imperative
  installs. They pollute the profile and are hostile to this system's model.
- Prefer modern CLI tools when available: `rg` over `grep`, `fd` over `find`,
  `bat` over `cat` for human-facing output, `gh` for GitHub, `jq` for JSON.

## Workflow

- **Fail loudly.** If a command errors, surface the error. Do not silently
  retry variations hoping something sticks, and do not paper over failures
  with fallbacks the user did not ask for.
- **Ask before destructive or system-level actions.** Anything that mutates
  state outside the working tree or rewrites shared history needs explicit
  go-ahead — system rebuilds, store GC, `flake.lock` changes, force-push,
  editing secrets. Read-only exploration does not.

## Voice

How to express things, both in replies to me and in text written on my
behalf.

### Code comments

Default to no comment. Prefer clearer names, types, or structure.

Add one only to preserve a non-obvious, durable constraint whose absence could cause an incorrect change: an invariant,
external limitation, necessary workaround, ordering requirement, or deliberate tradeoff.

Do not narrate code, restate names or requirements, explain ordinary behavior, label blocks, summarize changes, or
record tickets and implementation history. Planning context belongs in planning artifacts, not source comments.

### API documentation

Write public API documentation for callers. Describe only what they need for correct use: purpose, non-obvious inputs
and outputs, errors, side effects, lifecycle, ordering, ownership, concurrency, and useful examples. Omit private
helpers, control flow, storage, and rationale unless callers must account for them. Documentation should survive private
refactors that preserve behavior.

Never put ticket identifiers or issue links in shipped files unless they are required product data.
