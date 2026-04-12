# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ inputs, config, lib, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./disks.nix
      ./hardware.nix
    ];

  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      trusted-users = [ "root" "@wheel" ];
      substituters = [
        "https://cache.nixos-cuda.org"
      ];
      trusted-public-keys = [
        "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      ];
      download-buffer-size = 1048576000; # 1GB
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "construct";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  users.users.root.openssh = {
    authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIOsUvi/j/2Gs8QkZ5S0/bGsK/BhmU8n24eDFCc7GZx9 cardno:13_494_293"
    ];
  };

  environment.shells = [ pkgs.zsh ];
  programs.zsh.enable = true;

  users.users.nixos = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets.construct-password.path;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIOsUvi/j/2Gs8QkZ5S0/bGsK/BhmU8n24eDFCc7GZx9 cardno:13_494_293"
    ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  environment.systemPackages = with pkgs; [
    git
    vim
    neovim
    wget
    python3Packages.huggingface-hub
    inputs.llama-cpp.packages.${pkgs.stdenv.hostPlatform.system}.cuda
  ];

  services.openssh.enable = true;

  security.sudo.wheelNeedsPassword = false;

  delta.ripping.enable = true;
  delta.theme.enable = true;
  delta.theme.palette = "dev-null";

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
    };
  };

  services.llama-swap = {
    enable = true;
    package = pkgs.unstable.llama-swap;
    port = 11434;
    openFirewall = true;
    settings =
      let
        llama-cpp = inputs.llama-cpp.packages.${pkgs.stdenv.hostPlatform.system}.cuda;
        llama-server = lib.getExe' llama-cpp "llama-server";
      in
      {
        logLevel = "debug";
        healthCheckTimeout = 120;
        includeAliasesInList = true;
        models."gpt-oss:120b" = {
          cmd = ''
            ${llama-server} --port ''${PORT} 
            -m /models/gpt-oss-120b-F16.gguf 
            --chat-template-kwargs "{\"reasoning_effort\": \"medium\"}" 
            -fa on 
            --temp 1.0 --top-p 1.0 --top-k 0 -np 2
          '';
          ttl = 3600; # 1 hour
        };
        models."gemma3:27b" = {
          cmd = ''
            ${llama-server} --port ''${PORT} 
            -m /models/Gemma3/UD-Q6_K_XL.gguf 
            --mmproj /models/Gemma3/mmproj-BF16.gguf 
            -c 32768 
            -fa on 
            -ctk q8_0 
            -ctv q8_0 
            -ub 1024 
            -b 1024 
            --top-p 0.95 --top-k 64 --min-p 0.01 --temp 1.0 --prio 2
          '';
          ttl = 1500; # 15 min
        };
        models."GLM-4.7" = {
          cmd = ''
            ${llama-server} --port ''${PORT} -m /models/GLM-4.7/UD-Q4_K_XL.gguf 
            -fa on 
            --no-mmap 
            -ctk q8_0 -ctv q8_0
            --temp 0.7 --top-p 1.0
          '';
          ttl = 14400; # 4 hours
        };
        models.MiniMax-M2 = {
          cmd = ''
            ${llama-server} --port ''${PORT} 
            -m /models/MiniMax-M2.5/UD-Q4_K_XL.gguf 
            -fa on 
            -ctk q8_0 -ctv q8_0 
            --no-mmap 
            -b 4096 -ub 2048
            --temp 1.0 --top-p 0.95 --top-k 40 --min-p 0.01 --repeat-penalty 1.0
          '';
          ttl = 14400; # 4 hours
          aliases = [ "Haiku-4.5" "us.anthropic.claude-haiku-4-5-20251001-v1" ];
        };
        models."Qwen3.5-122b-a3b" = {
          cmd = ''
            ${llama-server} --port ''${PORT} 
            -m /models/Qwen3.5/122B/UD-Q4_K_XL.gguf
            -fa on 
            -ctk q8_0 -ctv q8_0 
            --temp 0.6 --top-p 0.95 --top-k 20 --min-p 0.0 --repeat-penalty 1.0 --presence-penalty 0.0
          '';
          ttl = 1500;
        };
        groups.coding = {
          swap = false;
          exclusive = true;
          members = [ "gemma3:27b" "MiniMax-M2" ];
        };
      };
  };

  services.hardware.openrgb = {
    package = pkgs.openrgb-with-all-plugins;
    enable = true;
    motherboard = "amd";
  };

  systemd.services.openrgb-set-color = {
    wantedBy = [ "multi-user.target" ];
    after = [ "openrgb.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${config.services.hardware.openrgb.package}/bin/openrgb -c 'FFFFFF' -b 100";
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

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


