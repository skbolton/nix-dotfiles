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

  boot.kernelParams = [
    "amd_iommu=off"
    "ttm.pages_limit=33554432"
    "ttm.page_pool_size=33554432"
  ];

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

  networking.firewall.allowedTCPPorts = [ 3010 config.services.paperless.port config.services.searx.settings.server.port ];

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

      paperless-gpt = {
        image = "icereed/paperless-gpt:latest";
        environmentFiles = [ config.sops.secrets.paperless-gpt-secrets.path ];
        environment = {
          PAPERLESS_BASE_URL = "http://cypher.home.arpa:${toString config.services.paperless.port}";
          MANUAL_TAG = "gpt";
          AUTO_TAG = "gpt-auto";
          AUTO_OCR_TAG = "gpt-ocr-auto";

          LLM_PROVIDER = "openai";
          LLM_MODEL = "Qwen3.5-27b-nothink";
          OCR_PROVIDER = "llm";
          VISION_LLM_PROVIDER = "openai";
          VISION_LLM_MODEL = "Qwen3.5-27b-nothink";
          OPENAI_BASE_URL = "http://cypher.home.arpa:11434/v1";
          OPENAI_API_KEY = "notneeded";
          PDF_UPLOAD = "false";
          PDF_OCR_COMPLETE_TAG = "paperless-gpt-ocr-complete";
          LOG_LEVEL = "info";
        };
      };
    };
  };

  services.caddy = {
    enable = true;
    environmentFile = config.sops.secrets.caddy-secrets.path;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/tailscale/caddy-tailscale@v0.0.0-20260106222316-bb080c4414ac" ];
      hash = "sha256-9CYQSdGAQwd1cmFuKT2RNzeiJ4DZoyrxvsLS4JDCFCY=";
    };

    virtualHosts."https://${config.services.paperless.domain}" = {
      extraConfig = ''
        bind tailscale/paper
        tailscale_auth
        reverse_proxy ${config.services.paperless.address}:${toString config.services.paperless.port} {
          header_up X-Webauth-User {http.auth.user.tailscale_user}
        }
      '';
    };

    virtualHosts."https://${config.services.vaultwarden.domain}" = {
      extraConfig = ''
        bind tailscale/vault
        tailscale_auth
        reverse_proxy ${config.services.vaultwarden.config.ROCKET_ADDRESS}:${toString config.services.vaultwarden.config.ROCKET_PORT} {
          header_up X-Webauth-User {http.auth.user.tailscale_user}
        }
      '';
    };
  };

  services.paperless = {
    enable = true;
    package = pkgs.unstable.paperless-ngx;
    dataDir = "/var/zion-data/paperless";
    domain = "paper.gorgon-procyon.ts.net";
    address = "0.0.0.0";
    passwordFile = config.sops.secrets.paperless-admin-password.path;
    database.createLocally = true;
  };

  services.vaultwarden = {
    enable = true;
    domain = "vault.gorgon-procyon.ts.net";
    dbBackend = "sqlite";
    backupDir = "/var/zion-data/vaultwarden";
    config.ROCKET_ADDRESS = "127.0.0.1";
    config.ROCKET_PORT = 8222;
    environmentFile = config.sops.secrets.vaultwarden-secrets.path;
  };

  services.searx = {
    enable = true;
    domain = "search.zionlab.online";
    settings = {
      server.port = 8333;
      server.bind_address = "0.0.0.0";
      server.secret_key = "$SEARXNG_SECRET_KEY";
    };
    environmentFile = config.sops.secrets.searxng-secrets.path;
  };

  services.llama-swap = {
    enable = true;
    port = 11434;
    openFirewall = true;
    settings =
      let
        llama-cpp = inputs.llama-cpp.packages.${pkgs.stdenv.hostPlatform.system}.vulkan;
        llama-server = lib.getExe' llama-cpp "llama-server";
      in
      {
        logLevel = "debug";
        healthCheckTimeout = 120;
        models."Qwen3.5-27b" = {
          cmd = ''
            ${llama-server} --port ''${PORT} 
            -m /models/Qwen3.5/27b/UD-Q6_K_XL.gguf
            --mmproj /models/Qwen3.5/mmproj-BF16.gguf
            -fa on 
            -ctk q8_0 -ctv q8_0 
            --temp 1.0 --top-p 0.95 --top-k 20 --min-p 0.0 --presence-penalty 1.5 --repeat-penalty 1.0
          '';
          ttl = 14400; # 4 hours
        };

        models."Qwen3.5-27b-nothink" = {
          cmd = ''
            ${llama-server} --port ''${PORT} 
            -m /models/Qwen3.5/27b/UD-Q6_K_XL.gguf
            --mmproj /models/Qwen3.5/mmproj-BF16.gguf
            --chat-template-kwargs '{"enable_thinking":false}'
            -fa on 
            -ctk q8_0 -ctv q8_0 
            --temp 1.0 --top-p 0.95 --top-k 20 --min-p 0.0 --presence-penalty 1.5 --repeat-penalty 1.0
          '';
          ttl = 14400; # 4 hours
        };
        groups.shared = {
          swap = false;
          exclusive = true;
          members = [ "Qwen3.5-27b" "Qwen3.5-27b-nothink" ];
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


