# Orlando's Dotfiles - Nix Edition

## Installing on a new machine

Enable flakes inside of installer

```bash
export NIX_CONFIG="experimental-features = nix-command flakes"
```

Clone dotfiles into `/mnt/etc/nixos`

```bash
# pull git package
nix-shell -p git
git clone https://github.com/skbolton/nix-dotfiles /mnt/etc/nixos
cd /mnt/etc/nixos
```

Create a new host directory for machine

```bash
mkdir hosts/$HOSTNAME
```

Generate config - this will scan the hardware and add a `hardware-configuration.nix` for host

```bash
nixos-generate-config --root /mnt
```

Move generated `hardware-configuration.nix` into host dir

> TODO: Maybe there is a way to set where to dump this file to?

```bash
mv hardware-configuration /hosts/$HOSTNAME
```

Remove `configuration.nix` that was generated. The other hosts have enough of a template to copy

```bash
rm configuration.nix
```

Make a `default.nix` for host

```
vim hosts/$HOSTNAME/default.nix
```

Copy and nudge contents of this file based on other hosts

> TODO: Maybe I can break some stuff out into more common shared code?

Add new host entry to `flake.nix`. Copy from a different host and then nudge `$HOSTNAME`.

Run installer

> This is going to ask some questions about accepting trust levels

```bash
nixos-install --flake .#$HOSTNAME
```

## Adding new hosts

If new host needs access to secrets than update the comment in `systems/x86_64-install-iso/minimal/default.nix` with the age key.

> Don't commit the secret dummy

Next build the image
```bash
nix build '.#install-isoConfigurations.minimal'
```

Do traditional installation of nixos and if secrets are needed copy the `/etc/orlando-age-key.txt` into the new users `~/.config/sops/age-key.txt`
