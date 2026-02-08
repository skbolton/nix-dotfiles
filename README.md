# Stephen Bolton's Dotfiles

Nix flake-based dotfiles using [snowfall-lib](https://github.com/snowfallorg/lib) for module organization.

## Structure

- `systems/<arch>-<platform>/<hostname>/` - NixOS and darwin system configurations
- `homes/<arch>-<platform>/<user>@<hostname>/` - Home Manager configurations
- `modules/<context>/<name>/` - Reusable modules
- `packages/<name>/` - Custom packages
- `overlays/<name>/` - Nixpkgs overlays

## Building Systems

```bash
# Build NixOS system
nixos-rebuild switch --flake .#<hostname>

# Build darwin system
darwin-rebuild switch --flake .#<hostname>

# Build home configuration
home-manager switch --flake .#<user>@<hostname>
```

## Creating a New Host

1. Create directory: `systems/<arch>-<platform>/<hostname>/`
2. Copy hardware config from installer to `./hardware-configuration.nix`
3. Create `default.nix`:

```nix
{ lib, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "<hostname>";
}
```

## Creating a New Home

1. Create directory: `homes/<arch>-<platform>/<user>@<hostname>/`
2. Create `default.nix` with home configuration

## ISO Generation

If new host needs access to secrets, update the comment in `systems/x86_64-install-iso/minimal/default.nix` with the age key.

> Don't commit the secret dummy

Build the installer ISO:
```bash
nix build '.#install-isoConfigurations.minimal'
```

Perform traditional Nixos installation. If secrets are needed, copy the `/etc/orlando-age-key.txt` into the new user's `~/.config/sops/age-key.txt`.
