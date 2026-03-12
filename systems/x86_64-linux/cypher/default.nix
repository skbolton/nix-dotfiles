# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ inputs, config, lib, pkgs, ... }:

{
  imports =
    [
      ./disks.nix
      ./hardware.nix
    ];

  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      trusted-users = [ "root" "@wheel" ];
      substituters = [
      ];
      trusted-public-keys = [
      ];
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "cypher";
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

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
    hashedPasswordFile = config.sops.secrets.cypher-password.path;
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIOsUvi/j/2Gs8QkZ5S0/bGsK/BhmU8n24eDFCc7GZx9 cardno:13_494_293"
    ];
  };

  environment.systemPackages = with pkgs; [
    postgresql
    arion
    pciutils
    git
    vim
    neovim
    wget
    python3Packages.huggingface-hub
    inputs.llama-cpp.packages.${pkgs.stdenv.hostPlatform.system}.vulkan
  ];

  services.openssh.enable = true;

  security.sudo.wheelNeedsPassword = false;

  delta.theme.enable = true;
  delta.theme.palette = "dev-null";

  virtualisation.arion = {
    backend = "docker";
    projects.affine.settings = {
      services.affine = {
        service.image = "ghcr.io/toeverything/affine:stable";
        service.ports = [ "3010:3010" ];
        service.volumes = [
          "/var/zion-data/affine/storage:/root/.affine/storage"
          "/var/zion-data/affine/config:/root/.affine/config"
        ];
        service.depends_on = {
          redis = { condition = "service_healthy"; };
          postgres = { condition = "service_healthy"; };
          affine_migration = { condition = "service_completed_successfully"; };
        };

        service.env_file = [ config.sops.secrets.affine-secrets.path ];
        service.environment = {
          REDIS_SERVER_HOST = "redis";
          AFFINE_INDEXER_ENABLED = "false";
        };

        service.restart = "unless-stopped";
      };

      services.affine_migration = {
        service.image = "ghcr.io/toeverything/affine:stable";
        service.volumes = [
          "/var/zion-data/affine/storage:/root/.affine/storage"
          "/var/zion-data/affine/config:/root/.affine/config"
        ];
        service.command = [ "sh" "-c" "node ./scripts/self-host-predeploy.js" ];
        service.env_file = [ config.sops.secrets.affine-secrets.path ];
        service.environment = {
          REDIS_SERVER_HOST = "redis";
          AFFINE_INDEXER_ENABLED = "false";
        };
        service.depends_on = {
          postgres.condition = "service_healthy";
          redis.condition = "service_healthy";
        };
        service.restart = "no";
      };

      services.redis = {
        service.image = "redis";
        service.healthcheck = {
          test = [ "CMD" "redis-cli" "--raw" "incr" "ping" ];
          interval = "10s";
          timeout = "5s";
          retries = 5;
        };
        service.restart = "unless-stopped";
      };

      services.postgres = {
        service.image = "pgvector/pgvector:pg16";
        service.volumes = [
          "/var/zion-data/affine/postgres:/var/lib/postgresql/data"
        ];
        service.env_file = [ config.sops.secrets.affine-secrets.path ];
        service.environment = {
          POSTGRES_INITDB_ARGS = "'--data-checksums'";
          POSTGRES_HOST_AUTH_METHOD = "trust";
        };
        service.healthcheck = {
          test =
            [ "CMD" "pg_isready" "-U" "affine" "-d" "affine" ];
          interval = "10s";
          timeout = "5s";
          retries = 5;
        };
        service.restart = "unless-stopped";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 3010 ];

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
    enable = false;
    port = 11434;
    openFirewall = true;
    settings =
      let
        llama-cpp = inputs.llama-cpp.packages.${pkgs.stdenv.hostPlatform.system}.vulkan;
        llama-server = lib.getExe' llama-cpp "llama-server";
      in
      {
        logLevel = "debug";
        oealthCheckTimeout = 120;
        models."gpt-oss:120b" = {
          cmd = ''
            ${llama-server} --port ''${PORT} -m /models/gpt-oss-120b-F16.gguf --chat-template-kwargs "{\"reasoning_effort\": \"medium\"}" -c 0 --jinja -fa on --no-mmap --temp 1.0 --top-p 1.0 --top-k 0 -np 2
          '';
          ttl = 3600; # 1 hour
        };
        models."qwen3-coder:30b-a3b" = {
          cmd = ''
            ${llama-server} --port ''${PORT} -m /models/Qwen3-Coder-30B-A3B-Instruct-UD-Q5_K_XL.gguf -ctk q8_0 -ctv q8_0 -c 65536 --jinja -ub 2048 -b 2048 --temp 0.7 --min-p 0.0 --top-p 0.80 --top-k 20 --repeat-penalty 1.05 -np 2
          '';
          ttl = 3600; # 1 hour
        };
        models."gemma3:27b" = {
          cmd = ''
            ${llama-server} --port ''${PORT} -m /models/Gemma3/UD-Q6_K_XL.gguf --mmproj /models/Gemma3/mmproj-BF16.gguf -ctk q8_0 -ctv q8_0 -c 32768 --jinja -ub 1024 -b 1024 -fa on --top-p 0.95 --top-k 64 --min-p 0.01 --temp 1.0 --prio 2
          '';
          ttl = 1500; # 15 min
        };
        models."GLM-4.7" = {
          cmd = ''
            ${llama-server} --port ''${PORT} -m /models/GLM-4.7/UD-Q4_K_XL.gguf 
            -c 0 
            --jinja 
            -fa on 
            --no-mmap 
            -ctk q8_0 -ctv q8_0
            --temp 0.7 --top-p 1.0
          '';
          ttl = 14400; # 4 hours
        };
        models."GLM-5" = {
          cmd = ''
            ${llama-server} --port ''${PORT} 
            -m /models/GLM-5/UD-IQ2_XXS.gguf 
            -c 0
            --threads 16
            -fa on
            --prio 3 
            --temp 1 
            --top-p 0.95
            -ot ".ffn_(up)_exps.=CPU"
            --parallel 1
            --no-mmap
            --batch-size 128
            --ubatch-size 128 
          '';
          ttl = 300; # 5 min
        };
        models.MiniMax-M2 = {
          cmd = ''
            ${llama-server} --port ''${PORT} 
            -m /models/MiniMax-M2.5/UD-Q4_K_XL.gguf 
            -c 0 
            -fa on 
            -ctk q8_0 -ctv q8_0 
            --tensor-split 1,3,3
            --no-mmap 
            --jinja 
            -ngl 99 
            --temp 1.0 --top-p 0.95 --top-k 40 --min-p 0.01 --repeat-penalty 1.0
          '';
          ttl = 14400; # 4 hours
        };
        models."Qwen3.5" = {
          cmd = ''
            ${llama-server} --port ''${PORT} 
            -m /models/Qwen3.5/UD-Q4_K_XL.gguf
            -c 0 
            -fa on 
            -ctk q8_0 -ctv q8_0 
            --no-mmap 
            --jinja 
            -ngl 99 
            --temp 0.6 --top-p 0.95 --top-k 20 --min-p 0.0 --repeat-penalty 1.0 --presence-penalty 0.0
          '';
          ttl = 14400; # 4 hours
        };
        groups.coding = {
          swap = false;
          exclusive = true;
          members = [ "gemma3:27b" "MiniMax-M2" ];
        };
      };
  };

  services.open-webui.enable = false;
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


