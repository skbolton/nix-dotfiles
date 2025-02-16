# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, inputs, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      inputs.nixos-hardware.nixosModules.framework-intel-core-ultra-series1
    ];

  services.fwupd.enable = true;
  services.fprintd.enable = true;

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.kernelPackages = pkgs.linuxPackages_6_11;

  fileSystems."/" =
    {
      device = "/dev/mapper/system";
      fsType = "btrfs";
      options = [ "subvol=@" "compress=zstd" "space_cache=v2" "noatime" ];
    };

  boot.initrd.luks.devices."system".device = "/dev/disk/by-partlabel/FRAME-SYSTEM";

  fileSystems."/home" =
    {
      device = "/dev/mapper/system";
      fsType = "btrfs";
      options = [ "subvol=@home" "compress=zstd" "space_cache=v2" "noatime" ];
    };

  fileSystems."/nix" =
    {
      device = "/dev/mapper/system";
      fsType = "btrfs";
      options = [ "subvol=@nix" "compress=zstd" "space_cache=v2" "noatime" ];
    };

  fileSystems."/swap" =
    {
      device = "/dev/mapper/system";
      fsType = "btrfs";
      options = [ "subvol=@swap" "compress=zstd" "space_cache=v2" "noatime" ];
    };

  fileSystems."/var/log" =
    {
      device = "/dev/mapper/system";
      fsType = "btrfs";
      options = [ "subvol=@var/log" "compress=zstd" "space_cache=v2" "noatime" ];
    };

  fileSystems."/var/lib/docker" =
    {
      device = "/dev/mapper/system";
      fsType = "btrfs";
      options = [ "subvol=@var/lib/docker" "compress=zstd" "space_cache=v2" "noatime" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-partlabel/FRAME-EFI";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices = [{ device = "/swap/swapfile"; }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp170s0.useDHCP = lib.mkDefault true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      vpl-gpu-rt
    ];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
