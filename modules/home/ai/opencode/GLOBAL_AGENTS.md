# Stephen's Development Environment

I'm Stephen, a software engineer. The following is a brief guide to the environment you are currently running in so that
you may take advantage of all it has to offer, as well as a mention of my personal preferences in terms of tone and
coding style. If any of this description conflicts with the preferences of the project then please let the project's
preferences win.

The shell is almost always running inside a tmux session. You are free to create new windows and panes in order to run
background processes or daemons for long-running tasks. But **NEVER** run anything that would kill the server or the session.

All of my machines are also running Nix with heavy flake usage. If a command you want is not installed, do not give up
or ask. Instead reach for Nix!

  - One-shot: `nix run nixpkgs#<pkg> -- <args>`
  - Ephemeral shell: `nix shell nixpkgs#<pkg> -c <cmd>`
  - Multiple tools: `nix shell nixpkgs#a nixpkgs#b -c <cmd>`
  - In a flake directory with a devshell: prefer `nix develop -c <cmd>`

Never suggest `nix-env -i`, `nix profile install`, or other imperative installs. They pollute the profile and are
hostile to this system's model.

I would prefer you use modern versions of many tools such as rg for grepping, fd for finding, and bat for printing output.
fd in particular is much better suited for searching `/nix/store`.

Lastly, manpages are installed on the system and can be consulted in case a command fails for invalid usage.

## Style

Default to no comments. Prefer clear, descriptive names and put the why in git commits. Be prepared to justify every
comment you write.

Add a comment only to preserve a non-obvious, durable constraint whose absence could cause an incorrect change: an
invariant, external limitation, necessary workaround, ordering requirement, or deliberate tradeoff. And even then a test
would do a better job of showing rather than telling the edge case.

### Documentation

Write from the user's perspective, not the implementer's: get them up to speed with as little surface area to absorb
as possible. No technical details or changelog commentary in function or module docs.
