# Agent Instructions

This flake manages the NixOS, nix-darwin, Home Manager, installer, and package configurations for all machines in this
repository. It uses [Snowfall Lib](https://snowfall.org/guides/lib/quickstart/) to discover files and generate flake
outputs from their paths.

## Repository Layout

Snowfall discovers components from directories containing a `default.nix`:

| Component | Discovery path | Output or behavior |
| --- | --- | --- |
| [Systems and images](https://snowfall.org/guides/lib/systems/) | `systems/<arch>/<name>/default.nix` | `nixosConfigurations.<name>`, `darwinConfigurations.<name>`, or `install-isoConfigurations.<name>` |
| [Homes](https://snowfall.org/guides/lib/homes/) | `homes/<arch>/<user>@<host>/default.nix` | `homeConfigurations."<user>@<host>"` |
| [Modules](https://snowfall.org/guides/lib/modules/) | `modules/{nixos,darwin,home}/**/default.nix` | Automatically imported into matching configurations |
| [Packages](https://snowfall.org/guides/lib/packages/) | `packages/<name>/default.nix` | `packages.<system>.<name>` and `pkgs.delta.<name>` |
| [Shells](https://snowfall.org/guides/lib/shells/) | `shells/<name>/default.nix` | `devShells.<system>.<name>` |
| [Overlays](https://snowfall.org/guides/lib/overlays/) | `overlays/<name>/default.nix` | Exported and applied to the flake's package sets |

Do not manually import shared modules; local supporting files may still be imported. This repository's `unstable`
overlay provides `pkgs.unstable`.

The default development shell lives at `shells/default/` and is entered with `nix develop` (or automatically via the
repository's `.envrc` when direnv is present). It provides tools used to work on this flake, such as `sops`.

Reusable module options use `config.delta.*` and `options.delta.*` by this project's convention. Snowfall discovers and
imports the modules, but each module still declares its own options.

## Validation Workflow

After changing Nix code, run the applicable steps below from the repository root. If a check fails or cannot run,
report it and do not describe validation as passing. Validation must not modify `flake.lock`; the commands below use
`--no-update-lock-file` to enforce this.

1. **Format every changed Nix file.**

   ```bash
   nix fmt --no-update-lock-file path/to/changed-file.nix [other-changed-file.nix...]
   ```

2. **Parse every changed Nix file.** This catches syntax errors without evaluating the full configuration.

   ```bash
   nix-instantiate --parse path/to/changed-file.nix >/dev/null
   ```

3. **Check the flake.** This evaluates recognized flake outputs for the current system and builds any checks defined by
   the flake. It does not fully validate Snowfall's Home Manager, nix-darwin, or generated-image outputs, so the
   targeted validation in the next step is still required.

   ```bash
   nix flake check --no-update-lock-file
   ```

4. **Build every affected output that the current machine can build.** `--no-link` prevents creation of a `result`
   symlink. Building realizes store paths but does not activate a system or Home Manager generation.

   ```bash
   nix build --no-link --no-update-lock-file '.#nixosConfigurations.<host>.config.system.build.toplevel'
   nix build --no-link --no-update-lock-file '.#darwinConfigurations.<host>.system'
   nix build --no-link --no-update-lock-file '.#homeConfigurations."<user>@<host>".activationPackage'
   nix build --no-link --no-update-lock-file '.#install-isoConfigurations.<name>'
   nix build --no-link --no-update-lock-file '.#packages.<system>.<name>'
   nix build --no-link --no-update-lock-file '.#devShells.<system>.default'
   ```

   Trace consumers before selecting outputs. Treat a shared module as affecting every configuration of the matching
   type unless a narrower scope can be demonstrated. If an affected output targets a platform unavailable to the
   current machine, at least force its evaluation by requesting its derivation path, then report that it was not built:

   ```bash
   nix eval --no-update-lock-file --raw '.#darwinConfigurations.<host>.system.drvPath'
   ```

Git-backed flake references ignore untracked files. To validate a new file without staging it, use a `path:.` reference
(for example, `nix flake check --no-update-lock-file 'path:.'`) only after inspecting untracked files for secrets or
generated artifacts that must not enter the Nix store. Do not stage files solely for validation.

## Safety Boundary

Configuration activation is always user-triggered. Never run commands that switch, boot, test, or activate a system or
home generation, including `nixos-rebuild switch`, `nixos-rebuild boot`, `nixos-rebuild test`, `darwin-rebuild switch`,
`home-manager switch`, or an activation script. Do not use `sudo` for validation. Building with `nix build --no-link`
and evaluating with `nix flake check` or `nix eval` are allowed because they do not apply the configuration.

Never place private keys or plaintext secrets in Nix source, including the installer image configuration. Do not
decrypt or modify secret material without explicit approval.
