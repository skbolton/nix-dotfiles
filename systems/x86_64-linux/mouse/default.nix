{ config, lib, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "@wheel" ];

  networking.hostName = "mouse"; # Define your hostname.
  # Pick only one of the below networking options.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  networking.networkmanager.wifi.backend = "iwd";

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  services.xserver = {
    enable = true;
    xkb.variant = "colemak";
    videoDrivers = [ "amdgpu" ];
  };
  console.useXkbConfig = true;

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;

  services.blueman.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };


  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  programs.zsh.enable = true;

  users.users.nixos = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets.orlando-password.path;
    extraGroups = [ "wheel" "docker" "networkmanager" "scanner" "lp" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIOsUvi/j/2Gs8QkZ5S0/bGsK/BhmU8n24eDFCc7GZx9 cardno:13_494_293"
    ];
  };

  # programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    firefox
    neovim
    git
    yubikey-personalization
    yubikey-manager
    wl-clipboard
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIOsUvi/j/2Gs8QkZ5S0/bGsK/BhmU8n24eDFCc7GZx9 cardno:13_494_293"
  ];

  services.openssh = {
    enable = true;
    settings = {
      # require public key authentication for better security
      PasswordAuthentication = false;
      #permitRootLogin = "yes";
    };
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.pathsToLink = [ "/share/zsh" ];

  services.udev.packages = [ pkgs.yubikey-personalization ];
  services.pcscd.enable = true;
  programs.ssh.startAgent = false;

  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };

  services.taskchampion-sync-server = {
    enable = true;
    openFirewall = true;
  };

  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      cloudflared = {
        image = "cloudflare/cloudflared:latest";
        environmentFiles = [
          config.sops.secrets.cloudflared-tunnel-creds.path
        ];
        cmd = [ "tunnel" "run" ];
      };
      taskwarior-gui = {
        image = "dcsunset/taskwarrior-webui:3";
        ports = [ "8081:80" ];
        volumes = [
          "${config.sops.secrets.taskwarrior-sync-server-credentials.path}:/.taskrc"
        ];
      };
      linkding = {
        image = "sissbruecker/linkding:latest";
        ports = [ "8082:9090" ];
        volumes = [
          "/var/zion-data/linkding:/etc/linkding/data"
        ];
        environment = {
          LD_ENABLE_AUTH_PROXY = "True";
          LD_AUTH_PROXY_USERNAME_HEADER = "HTTP_CF_ACCESS_AUTHENTICATED_USER_EMAIL";
          LD_AUTH_PROXY_LOGOUT_URL = "https://zionlab.cloudflareaccess.com/cdn-cgi/access/logout";
          LD_CSRF_TRUSTED_ORIGINS = "https://links.zionlab.online";
        };
      };
      beaverhabits = {
        image = "daya0576/beaverhabits:latest";
        ports = [ "8084:8080" ];
        volumes = [
          "/var/zion-data/beaverhabits:/app/.user/"
        ];
        environment = {
          FIRST_DAY_OF_WEEK = "0";
          HABITS_STORAGE = "DATABASE";
          MAX_USER_COUNT = "1";
          INDEX_SHOW_HABIT_COUNT = "false";
        };
      };
      kavita = {
        image = "jvmilazz0/kavita:latest";
        ports = [ "8085:5000" ];
        environment = {
          TZ = "America/New_York";
        };
        volumes = [
          "/mnt/Books:/Books"
        ];
      };
    };
  };

  delta.clipboard-share = {
    enable = true;
    type = "server";
    server.hostname = "10.100.0.10";
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 8081 8082 8084 8085 ];

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}

