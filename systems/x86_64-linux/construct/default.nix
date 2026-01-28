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
    port = 11434;
    openFirewall = true;
    settings =
      let
        llama-cpp = inputs.llama-cpp.packages.${pkgs.stdenv.hostPlatform.system}.cuda;
        llama-server = lib.getExe' llama-cpp "llama-server";
      in
      {
        logLevel = "debug";
        healthCheckTimeout = 60;
        models."gpt-oss:120b" = {
          cmd = ''
            ${llama-server} --port ''${PORT} -m /models/gpt-oss-120b-F16.gguf --chat-template-kwargs "{\"reasoning_effort\": \"high\"}" -c 0 --jinja -ub 2048 -b 2048 -fa on --no-mmap --temp 1.0 --top-p 1.0 --top-k 0 -np 2
          '';
          ttl = 3600; # 1 hour
        };
        models."qwen3-coder:30b-a3b" = {
          cmd = ''
            ${llama-server} --port ''${PORT} -m /models/Qwen3-Coder-30B-A3B-Instruct-UD-Q5_K_XL.gguf -ctk q8_0 -ctv q8_0 -c 65536 --jinja -ub 2048 -b 2048 --temp 0.7 --min-p 0.0 --top-p 0.80 --top-k 20 --repeat-penalty 1.05 -np 2
          '';
          ttl = 3600; # 1 hour
        };
        models."qwen3-coder:480b-a35b" = {
          cmd = ''
            ${llama-server} --port ''${PORT} -m /models/Qwen3-Coder-480B-A35B-Instruct-UD-Q2_K_XL-00001-of-00004.gguf -ctk q8_0 -ctv q8_0 -c 8192 -ot ".ffn_(up|down)_exps.=CPU" --jinja -ub 2048 -b 2048 --temp 0.7 --min-p 0.0 --top-p 0.80 --top-k 20 --repeat-penalty 1.05 -np 2
          '';
          ttl = 3600; # 1 hour
        };
        models."gemma3:27b" = {
          cmd = ''
            ${llama-server} --port ''${PORT} -m /models/Gemma3/UD-Q6_K_XL.gguf --mmproj /models/Gemma3/mmproj-BF16.gguf -ctk q8_0 -ctv q8_0 -c 32768 --jinja -ub 1024 -b 1024 -fa on --top-p 0.95 --top-k 64 --min-p 0.01 --temp 1.0 --prio 2
          '';
          ttl = 300; # 5 min
        };
        models."GLM-4.6" = {
          cmd = ''
            ${llama-server} --port ''${PORT} -m /models/GLM-4.6-UD-Q2_K_XL-00001-of-00003.gguf --split-mode row -c 8192 --jinja -fa on -ngl 99 -ot ".ffn_.*_exps.=CPU"
          '';
          ttl = 300; # 5 min
        };
        models."GLM-4.7" = {
          cmd = ''
            ${llama-server} --port ''${PORT} -m /models/GLM-4.7/UD-Q2_K_XL.gguf -c 0 --jinja -fa on --no-mmap -ngl 99"
          '';
          ttl = 14400; # 4 hours
        };
        models.Devstral2 = {
          cmd = ''
            ${llama-server} --port ''${PORT} -m /models/Devstral2/Devstral-2-123B-Instruct-2512-UD-Q6_K_XL-00001-of-00003.gguf -c 32768 -ctk q8_0 -ctv q8_0 --jinja -ngl 99 --temp 0.15"
          '';
          ttl = 300; # 5 min
        };
        models.Devstral2-Small = {
          cmd = ''
            ${llama-server} --port ''${PORT} -m /models/Devstral2/Devstral-Small-2-24B-Instruct-2512-UD-Q8_K_XL.gguf -c 0 -fa on --jinja -ngl 99 --temp 0.15"
          '';
          ttl = 300; # 5 min
        };
        models.MiniMax-M2 = {
          cmd = ''
            ${llama-server} --port ''${PORT} -m /models/MiniMax-M2.1/UD-Q4_K_XL.gguf -c 0 -fa on -ctk q8_0 -ctv q8_0 --no-mmap --jinja -ngl 99 --temp 1.0 --top-p 0.95 --top-k 40"
          '';
          ttl = 14400; # 4 hours
        };
        models."llama3.2:3b" = {
          cmd = ''
            ${llama-server} --port ''${PORT} -m /models/unsloth_Llama-3.2-3B-Instruct-GGUF_Llama-3.2-3B-Instruct-UD-Q5_K_XL.gguf -c 8192 --jinja 
          '';
          ttl = 3600; # 60 mins
        };
        groups.coding = {
          swap = false;
          exclusive = true;
          members = [ "qwen3-coder:30b-a3b" "gpt-oss:120b" ];
        };
      };
  };

  services.open-webui.enable = true;
  services.open-webui.package = pkgs.unstable.open-webui;
  services.open-webui.openFirewall = true;
  services.open-webui.host = "0.0.0.0";
  services.open-webui.port = 8080;
  services.open-webui.environment = {
    WEBUI_AUTH_TRUSTED_EMAIL_HEADER = "Cf-Access-Authenticated-User-Email";
    ANONYMIZED_TELEMETRY = "False";
    DO_NOT_TRACK = "True";
    SCARF_NO_ANALYTICS = "True";
  };

  services.hardware.openrgb = {
    package = pkgs.openrgb-with-all-plugins;
    enable = true;
    motherboard = "amd";
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


