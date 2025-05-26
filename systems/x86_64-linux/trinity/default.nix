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

  fonts.fontDir.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "@wheel" ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  networking.hostName = "trinity";
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
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    xkb.variant = "colemak";
    videoDrivers = [ "amdgpu" ];
    windowManager.awesome.enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  environment.shells = [ pkgs.zsh ];
  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.orlando = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets.orlando-password.path;
    extraGroups = [ "wheel" "docker" "networkmanager" "scanner" "lp" ]; # Enable ‘sudo’ for the user.
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
    qmk
    obs-studio
    simple-scan
    sops
    (google-cloud-sdk.withExtraComponents [
      google-cloud-sdk.components.kubectl
      google-cloud-sdk.components.gke-gcloud-auth-plugin
      google-cloud-sdk.components.pubsub-emulator
    ])
  ];

  delta.tailscale.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.pathsToLink = [ "/share/zsh" ];

  services.udev.packages = [ pkgs.yubikey-personalization ];
  services.pcscd.enable = true;
  programs.ssh.startAgent = false;

  services.openssh = {
    enable = true;
    settings = {
      # require public key authentication for better security
      PasswordAuthentication = false;
      #permitRootLogin = "yes";
    };
  };

  services.gvfs.enable = true;

  services.dbus.packages = [ pkgs.gcr ];

  programs.dconf.enable = true;

  programs.hyprland.enable = true;
  programs.river.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-hyprland ];
    wlr.enable = true;
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
    extraConfig.pipewire.adjust-sample-rate = {
      "context.properties" = {
        "default.clock.rate" = 192000;
        "defautlt.allowed-rates" = [ 192000 48000 44100 ];
      };
    };
  };

  security.pam = {
    services = {
      login.u2fAuth = false;
      sudo.u2fAuth = true;
    };
    u2f = {
      enable = true;
      settings.cue = true;
    };
  };

  services.flatpak.enable = true;
  services.hardware.bolt.enable = true;

  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  hardware.sane = {
    enable = true;
    brscan5.enable = true;
  };

  services.blueman.enable = true;

  services.hardware.openrgb = {
    package = pkgs.openrgb-with-all-plugins;
    enable = true;
  };

  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };

  # Personal dashboard config

  services.grafana = {
    enable = true;
    settings = {
      server.http_port = 2333;
      server.http_addr = "0.0.0.0";
    };
  };

  services.prometheus = {
    enable = true;
    port = 9001;
    scrapeConfigs = [
      {
        job_name = "wakatime-exporter";
        static_configs = [{
          # TODO: Stop hardcoding port - env of docker container?
          targets = [ "127.0.0.1:9212" ];
        }];
      }
    ];
  };

  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      wakatime-exporter = {
        image = "macropower/wakatime-exporter";
        environmentFiles = [ config.sops.secrets.wakatime-api-key.path ];
        ports = [ "9212:9212" ];
      };
    };
  };

  services.ollama = {
    enable = true;
    acceleration = "rocm";
    loadModels = [ "deepseek-r1:32b" "mistral-small:24b" ];
    rocmOverrideGfx = "11.0.0";
  };

  services.open-webui.enable = true;
  services.open-webui.openFirewall = true;
  services.open-webui.host = "0.0.0.0";
  services.open-webui.environment = {
    WEBUI_AUTH = "False";
    ANONYMIZED_TELEMETRY = "False";
    DO_NOT_TRACK = "True";
    SCARF_NO_ANALYTICS = "True";
  };

  delta.openlinkhub.enable = true;

  documentation.dev.enable = true;
  documentation.man.enable = true;
  documentation.man.generateCaches = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

