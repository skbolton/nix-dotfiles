# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-label/NIX-SYSTEM";
      fsType = "btrfs";
      options = [ "subvol=@" "compress=zstd" "ssd" "noatime" "space_cache=v2"];
    };

  boot.initrd.luks.devices."system".device = "/dev/disk/by-partlabel/LENOVO-SYSTEM";

  fileSystems."/home" =
    { device = "/dev/disk/by-label/NIX-SYSTEM";
      fsType = "btrfs";
      options = [ "subvol=@home" "compress=zstd" "ssd" "noatime" "space_cache=v2"];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-label/NIX-SYSTEM";
      fsType = "btrfs";
      options = [ "subvol=@nix" "compress=zstd" "ssd" "noatime" "space_cache=v2"];
    };

  fileSystems."/var/log" =
    { device = "/dev/disk/by-label/NIX-SYSTEM";
      fsType = "btrfs";
      options = [ "subvol=@var/log" "compress=zstd" "ssd" "noatime" "space_cache=v2"];
    };

  fileSystems."/var/lib/docker" =
    { device = "/dev/disk/by-label/NIX-SYSTEM";
      fsType = "btrfs";
      options = [ "subvol=@var/lib/docker" "compress=zstd" "ssd" "noatime" "space_cache=v2"];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/NIX-EFI";
      fsType = "vfat";
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
