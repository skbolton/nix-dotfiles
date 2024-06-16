# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "electron-25.9.0"
    ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };

  networking.hostName = "neo";
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  networking.networkmanager.wifi.backend = "iwd";

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver = {
    xkb.variant = "colemak";
    enable = true;
    videoDrivers = [ "i915" ];

    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    windowManager.awesome.enable = true;
  };

  console.useXkbConfig = true;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  hardware = {
    bluetooth.enable = true;
    enableRedistributableFirmware = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  environment.shells = [ pkgs.zsh ];
  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.orlando = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets.orlando-password.path;
    extraGroups = [ "wheel" "docker" "networkmanager" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    neovim
    git
    wget
    yubikey-personalization
    yubikey-manager
    pavucontrol
    pulseaudio
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.udev.packages = [ pkgs.yubikey-personalization ];
  services.pcscd.enable = true;
  services.blueman.enable = true;
  programs.ssh.startAgent = false;

  services.openssh = {
    enable = true;
    settings = {
      # require public key authentication for better security
      PasswordAuthentication = false;
      #permitRootLogin = "yes";
    };
  };

  services.dbus.packages = [ pkgs.gcr ];

  programs.dconf.enable = true;

  # services.auto-cpufreq.enable = true;

  xdg.portal = {
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "btrfs";

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  security.pam.services = {
    login.u2fAuth = false;
    sudo.u2fAuth = true;
  };


  security.pam.u2f = {
    enable = true;
    cue = true;
  };

  programs.light = {
    enable = true;
    brightnessKeys.step = 5;
    brightnessKeys.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

