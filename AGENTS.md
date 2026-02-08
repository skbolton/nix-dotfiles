# AGENTS.md

This document provides guidance for agentic coding agents operating in this Nix dotfiles repository.

## Repository Overview

This is a Nix flake-based dotfiles configuration using [snowfall-lib](@snowfall.txt) for module organization. The repository manages:
- **Systems**: NixOS and darwin configurations in `systems/<arch>-<platform>/<hostname>/`
- **Homes**: Home Manager configurations in `homes/<arch>-<platform>/<user>@<hostname>/`
- **Modules**: Reusable modules in `modules/<platform>/<category>/<name>/`
- **Packages**: Custom packages in `packages/<name>/`
- **Overlays**: Nixpkgs overlays in `overlays/<name>/`
- **Shells**: Development shells in `shells/<name>/`

## Build Commands

### Flake Evaluation and Building

```bash
# Evaluate the flake and show what will be built
nix flake check
nix flake show

# Build a specific NixOS system configuration
nixos-rebuild switch --flake .#<hostname>

# Build a specific darwin system configuration
darwin-rebuild switch --flake .#<hostname>

# Build home configuration
home-manager switch --flake .#<user>@<hostname>

# Build a specific package (auto-discovered from packages/ directory)
nix build '.#packages.<system>.<name>'
# Example: nix build '.#packages.x86_64-linux.frg'

# Build installer ISO (from x86_64-install-iso)
nix build '.#install-isoConfigurations.minimal'
```

### Development Shells

```bash
# Enter development shell (auto-discovers shells/ directory)
nix develop

# Enter a specific shell
nix develop '.#default'
```

### Linting and Formatting

```bash
# Format all Nix files
nix fmt

# Check for syntax errors
nix-instantiate --parse <file.nix>

# Evaluate with strictness checks
nix eval --strict '<nixpkgs>' -A lib

# Check for unused imports or references
nix flake check --impure
```

### Testing

```bash
# Dry-run NixOS system switch
nixos-rebuild dry-run --flake .#<hostname>

# Dry-run darwin system switch
darwin-rebuild dry-run --flake .#<hostname>

# Dry-run home switch
home-manager dry-switch --flake .#<user>@<hostname>

# Check flake outputs
nix flake check
```

## Code Style Guidelines

### Module Structure

All module files should follow this pattern:

```nix
{ lib, config, pkgs, inputs, ... }:

with lib;
let
  cfg = config.delta.<module-name>;
in
{
  options.delta.<module-name> = with types; {
    enable = mkEnableOption "<description>";
  };

  config = {
    # Module implementation
  };
}
```

### Imports

- Use `with lib;` for Nixpkgs/lib functions
- NixOS hardware config files use relative paths: `./hardware-configuration.nix` or `./hardware.nix`
- NixOS disko disk configs: `./disks.nix`
- Home modules go in `modules/home/<category>/`
- NixOS modules go in `modules/nixos/`
- Desktop modules go in `modules/home/desktop/`

### Naming Conventions

- **Option names**: Use `delta.` prefix (namespace defined in flake.nix)
- **Hostnames**: Use lowercase descriptive names (neo, trinity, framework, construct, mouse, niobe)
- **Packages**: Descriptive snake_case names (frg, dsearch, task-fs)
- **Modules**: Descriptive names matching their function (git, zsh, tmux, neovim)
- **Home configs**: Format is `<user>@<hostname>` (e.g., `orlando@neo`, `s.bolton@niobe`)

### Attribute Sets

- Use shorthand attribute set syntax when possible: `{ ... }` vs `rec { ... }`
- Keep attribute sets organized by category
- Use `mkIf`, `mkMerge`, `mkOrder` for conditional module composition

### Package Definitions

```nix
{ writeShellApplication, ripgrep, bat, fzf, ... }:

writeShellApplication {
  name = "<package-name>";
  runtimeInputs = [ ripgrep bat fzf ];
  text = builtins.readFile ./script.sh;
}
```

### Overlays

```nix
final: prev: {
  # Add packages to final pkgs
}
```

## Snowfall-lib Integration

This flake uses `snowfall-lib.mkFlake` which auto-discovers:
- Packages from `packages/**/default.nix`
- Modules from `modules/**/default.nix`
- Overlays from `overlays/**/default.nix`
- Shells from `shells/**/default.nix`
- Systems from `systems/**/default.nix`
- Homes from `homes/**/default.nix`

### Key Configuration (from flake.nix)

- **Namespace**: `delta` (options use `delta.*`)
- **Channels**: nixpkgs (nixos-25.11), unstable, nixos-generators, darwin, home-manager
- **Global modules applied to all NixOS**: stylix, sops, disko
- **Global modules applied to all darwin**: stylix, nix-homebrew
- **Global modules applied to all homes**: sops

### External Inputs Available

- `inputs.nixpkgs` - Stable channel
- `inputs.unstable` - Unstable channel
- `inputs.darwin` - nix-darwin
- `inputs.home-manager` - Home Manager
- `inputs.sops-nix` - Secrets management
- `inputs.stylix` - Theming
- `inputs.disko` - Disk partitioning
- `inputs.nixos-generators` - System image generation
- `inputs.nixos-hardware` - Hardware-specific configs
- `inputs.nix-homebrew` - Homebrew on macOS

## Adding New Components

### New NixOS System

```bash
# 1. Create directory structure
mkdir -p systems/x86_64-linux/<hostname>

# 2. Generate hardware config (from installer)
# Copy /etc/nixos/hardware-configuration.nix to systems/x86_64-linux/<hostname>/hardware-configuration.nix

# 3. Create default.nix with system configuration:
{ lib, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/<category>/<module>
  ];

  networking.hostName = "<hostname>";
}
```

### New Darwin System

```bash
# 1. Create directory structure
mkdir -p systems/aarch64-darwin/<hostname>

# 2. Create default.nix with system configuration
```

### New Home

```bash
# 1. Create directory structure
mkdir -p homes/x86_64-linux/<user>@<hostname>

# 2. Create default.nix with home configuration
```

### New Module

```bash
# 1. Create directory (choose platform and category)
mkdir -p modules/<nixos|home>/<category>/<module-name>

# 2. Create default.nix
```

### New Package

```bash
# 1. Create directory
mkdir -p packages/<package-name>

# 2. Create default.nix
```

### New Overlay

```bash
# 1. Create directory
mkdir -p overlays/<overlay-name>

# 2. Create default.nix
```

## Secrets Management

This repository uses sops-nix for secrets:
- Secrets stored encrypted in repository (`.sops.yaml` defines rules)
- Age keys at `~/.config/sops/age-key.txt` on target systems
- Secrets referenced as `config.sops.secrets.<name>.path`

## Common Patterns

- Use `mkIf cfg.enable` to conditionally enable features
- Use `mkMerge` to combine multiple configuration parts
- Use `mkOrder` to control module evaluation order
- Access unstable packages via `pkgs.unstable.<package>`
- Access inputs in modules via `inputs.<input-name>`

## Available Utilities

 snowfall-lib provides utilities accessible via `lib`:
- `lib.snowfall.fs.*` - File system utilities (readDir, get-files, etc.)
- `lib.snowfall.attrs.*` - Attribute set utilities (merge-deep, merge-shallow)
- `lib.snowfall.system.*` - System configuration helpers
- `lib.snowfall.home.*` - Home Manager helpers
- `lib.snowfall.flake.*` - Flake utilities
