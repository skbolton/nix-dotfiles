{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.delta.llama-swap;
  settingsFormat = pkgs.formats.yaml { };
  configFile = settingsFormat.generate "config.yaml" cfg.settings;
in
{
  options.delta.llama-swap = {
    enable = lib.mkEnableOption "the llama-swap service";

    package = lib.mkPackageOption pkgs "llama-swap" { };

    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "localhost";
      example = "0.0.0.0";
      description = ''
        Address that llama-swap listens on.
      '';
    };

    port = lib.mkOption {
      default = 8080;
      example = 11343;
      type = lib.types.port;
      description = ''
        Port that llama-swap listens on.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to open the firewall for llama-swap.
        This adds {option}`port` to [](#opt-networking.firewall.allowedTCPPorts).
      '';
    };

    settings = lib.mkOption {
      type = lib.types.submodule { freeformType = settingsFormat.type; };
      description = ''
        llama-swap configuration. Refer to the [llama-swap example configuration](https://github.com/mostlygeek/llama-swap/blob/main/config.example.yaml)
        for details on supported values.
      '';
      example = lib.literalExpression ''
        let
          llama-cpp = pkgs.llama-cpp.override { rocmSupport = true; };
          llama-server = lib.getExe' llama-cpp "llama-server";
        in
        {
          healthCheckTimeout = 60;
          models = {
            "some-model" = {
              cmd = "''${llama-server} --port ''${PORT} -m /var/lib/llama-cpp/models/some-model.gguf -ngl 0 --no-webui";
              aliases = [
                "the-best"
              ];
            };
            "other-model" = {
              proxy = "http://127.0.0.1:5555";
              cmd = "''${llama-server} --port 5555 -m /var/lib/llama-cpp/models/other-model.gguf -ngl 0 -c 4096 -np 4 --no-webui";
              concurrencyLimit = 4;
            };
          };
        };
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.llama-swap = {
      description = "Model swapping for LLaMA C++ Server / SGLang Docker";
      after = [ "network.target" "docker.service" ]; # Ensure docker is ready
      requires = [ "docker.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "exec";
        ExecStart = "${lib.getExe cfg.package} ${
          lib.escapeShellArgs 
            [
              "--listen=${cfg.listenAddress}:${toString cfg.port}"
              "--config=${configFile}"
            ]
        }";
        Restart = "on-failure";
        RestartSec = 3;

        # --- DOCKER & GPU ACCESS MODIFICATIONS ---

        # 1. User must be in the docker group to talk to the socket
        DynamicUser = true;
        SupplementaryGroups = [ "docker" ];

        # 2. Grant access to GPU devices and Docker socket
        PrivateDevices = false;
        BindPaths = [ "/var/run/docker.sock" ];

        # 3. Relax Hardening to allow sub-processes and container namespaces
        # Docker needs to be able to create namespaces and manage probes
        RestrictNamespaces = false;
        ProtectProc = "default";
        ProcSubset = "all";

        # SGLang/Docker needs more syscalls than the standard @system-service
        SystemCallFilter = [ "@system-service" "@network-io" "@file-system" "@process" ];
        SystemCallArchitectures = "native";

        # Keep some hardening but allow Docker interaction
        NoNewPrivileges = false; # Set to false if docker wrappers need suid
        ProtectSystem = "full";
        ProtectHome = "read-only";
        ReadOnlyPaths = [ "/var/run/docker.sock" ];

        # Environmental needs
        WorkingDirectory = "/tmp";
      };
    };

    # Ensure the firewall is open if requested
    networking.firewall = lib.mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };
  };
}
