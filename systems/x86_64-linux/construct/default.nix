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

  users.users.contra = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets.contra-password.path;
    extraGroups = [ "wheel" "docker" ];
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
  services.openssh.extraConfig = ''
    StreamLocalBindUnlink yes
  '';

  security.sudo.wheelNeedsPassword = false;

  delta.ripping.enable = true;
  delta.theme.enable = true;
  delta.theme.palette = "dev-null";
  delta.tailscale.enable = true;

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

  delta.llama-swap = {
    enable = true;
    package = pkgs.unstable.llama-swap;
    listenAddress = "0.0.0.0";
    port = 11434;
    openFirewall = true;
    settings =
      let
        llama-cpp = inputs.llama-cpp.packages.${pkgs.stdenv.hostPlatform.system}.cuda;
        llama-server = lib.getExe' llama-cpp "llama-server";
      in
      {
        logLevel = "debug";
        healthCheckTimeout = 900;
        includeAliasesInList = true;
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
        models."MiniMax-M2" = {
          cmdStop = "${pkgs.docker}/bin/docker stop \${MODEL_ID}";
          cmd = ''
            ${pkgs.docker}/bin/docker run
            --rm --name ''${MODEL_ID}
            --shm-size 32g  
            --ipc host
            --ulimit memlock=-1  
            --ulimit stack=67108864  
            -p ''${PORT}:5000  
            -v /models:/mnt/data/models  
            -e SGLANG_ENABLE_JIT_DEEPGEMM=0
            -e TORCH_ALLOW_TF32_CUBLAS_OVERRIDE=1
            -e SGLANG_CUSTOM_ALLREDUCE_ALGO=oneshot
            -e NCCL_P2P_DISABLE=1
            -e NCCL_IB_DISABLE=1
            -e NCCL_NVLS_ENABLE=0
            -e NCCL_CUMEM_ENABLE=0
            -e B12X_MOE_FORCE_A16=1
            -e CUDA_MODULE_LOADING=LAZY
            -e OMP_NUM_THREADS=16
            -e MKL_NUM_THREADS=16
            --device=nvidia.com/gpu=all
            voipmonitor/sglang:cu130
            sglang serve 
              --sleep-on-idle 
              --model-path /mnt/data/models/MiniMax-M2.7/NVFP4
              --served-model-name MiniMax-M2.7     
              --reasoning-parser minimax
              --tool-call-parser minimax-m2     
              --tp 2  
              --enable-pcie-oneshot-allreduce
              --pcie-oneshot-allreduce-max-size 8388608
              --enable-torch-compile  
              --trust-remote-code
              --chunked-prefill-size 4096
              --quantization modelopt_fp4  
              --num-continuous-decode-steps 4
              --enable-mixed-chunk
              --prefill-max-requests 4
              --max-running-requests 8
              --cuda-graph-bs 1 2 4 6 8
              --cuda-graph-max-bs 4
              --kv-cache-dtype fp8_e4m3
              --moe-runner-backend b12x  
              --fp4-gemm-backend b12x         
              --attention-backend flashinfer
              --mem-fraction-static 0.95
              --host 0.0.0.0 --port 5000
          '';
          environment = [
            "CUDA_VISIBLE_DEVICES=0,1"
          ];
          ttl = 43200; # 12 hours
        };
        models."MiniMax-M3" = {
          cmdStop = "${pkgs.docker}/bin/docker stop \${MODEL_ID}";
          cmd = ''
            ${pkgs.docker}/bin/docker run
            --rm --name ''${MODEL_ID}
            --shm-size 32g  
            --ulimit memlock=-1  
            --ulimit stack=67108864  
            --ipc host
            --network host
            -v /models:/mnt/data/models  
            -e CUTE_DSL_ARCH=sm_120a
            -e NCCL_SOCKET_IFNAME=lo
            -e GLOO_SOCKET_IFNAME=lo
            -e NCCL_DEBUG=INFO
            -e HF_HUB_OFFLINE=1
            -e TRANSFORMERS_OFFLINE=1
            -e SAFETENSORS_FAST_GPU=1
            -e VLLM_MINIMAX_M3_ENABLE_TORCH_COMPILE=1
            -e VLLM_USE_BREAKABLE_CUDAGRAPH=0
            -e VLLM_USE_AOT_COMPILE=1
            -e VLLM_USE_B12X_FP8_GEMM=0
            -e VLLM_USE_B12X_MOE=1
            -e VLLM_USE_B12X_MINIMAX_M3_MSA=1
            -e VLLM_USE_B12X_SPARSE_INDEXER=1
            -e VLLM_ENABLE_PCIE_ALLREDUCE=1
            -e VLLM_PCIE_ALLREDUCE_BACKEND=b12x
            -e VLLM_PCIE_ONESHOT_ALLREDUCE_MAX_SIZE=64KB
            -e B12X_DYNAMIC_DETERMINISTIC_OUTPUT=0
            -e B12X_LOG_CUTE_COMPILES_AFTER_ENGINE_START=1
            --device=nvidia.com/gpu=all
            voipmonitor/vllm:chthonic-consecration-76378e8-b12x-465cb6e-glm51a16fix-cu132
            bash -lc 
            'unset NCCL_GRAPH_FILE NCCL_TOPO_FILE; exec /opt/venv/bin/python -m vllm.entrypoints.cli.main serve "$@"' --
              /mnt/data/models/MiniMax-M3/MXFP8-NVFP4
              --served-model-name MiniMax-M3 Delta
              --trust-remote-code 
              --host 0.0.0.0 
              --port ''${PORT}
              --tensor-parallel-size 3
              --kv-offloading-backend native
              --kv-offloading-size 32
              --mm-encoder-tp-mode data 
              --gpu-memory-utilization 0.98
              --max-num-batched-tokens 2048 
              --max-model-len 196608
              --max-num-seqs 2
              --quantization modelopt_mixed 
              --kv-cache-dtype fp8_e4m3 
              --attention-backend B12X_ATTN 
              --linear-backend b12x 
              --moe-backend b12x 
              -cc.mode=VLLM_COMPILE 
              -cc.cudagraph_mode=FULL_AND_PIECEWISE 
              --block-size 128 
              --load-format fastsafetensors 
              --enable-chunked-prefill 
              --enable-prefix-caching 
              --skip-mm-profiling 
              --reasoning-parser minimax_m3 
              --enable-auto-tool-choice 
              --tool-call-parser minimax_m3
          '';
          environment = [
            "CUDA_VISIBLE_DEVICES=0,1,2"
          ];
          aliases = [ "Delta" ];
          ttl = 43200; # 12 hours
        };
        "Step-3.7-Flash" = {
          cmdStop = "${pkgs.docker}/bin/docker stop \${MODEL_ID}";
          cmd = ''
            ${pkgs.docker}/bin/docker run 
              --rm --name ''${MODEL_ID}
              --shm-size 32g  
              --ipc host
              --ulimit memlock=-1  
              --ulimit stack=67108864  
              --device=nvidia.com/gpu=all
              -p ''${PORT}:5000  
              -v /models:/mnt/data/models  
              vllm/vllm-openai:stepfun37
                /mnt/data/models/Step-3.7-Flash/NVFP4
                --host 0.0.0.0 
                --port 5000
                --served-model-name ''${MODEL_ID}
                --tensor-parallel-size 2 
                --gpu-memory-utilization 0.94
                --enable-expert-parallel 
                --trust-remote-code 
                --quantization modelopt 
                --kv-cache-dtype fp8 
                --reasoning-parser step3p5 
                --enable-auto-tool-choice 
                --tool-call-parser step3p5 
                --speculative_config '{"method": "mtp", "num_speculative_tokens": 3}'
                --async-scheduling
          '';
          environment = [
            "CUDA_VISIBLE_DEVICES=0,1"
          ];
          ttl = 43200; # 12 hours
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

  services.hermes-agent = {
    enable = true;
    environment = {
      SEARXNG_URL = "http://cypher.home.arpa:8333";
      API_SERVER_ENABLED = "true";
      API_SERVER_PORT = "8642";
      API_SERVER_HOST = "0.0.0.0";
      API_SERVER_MODEL_NAME = "Mira";
    };
    environmentFiles = [ config.sops.secrets.hermes-agent-env.path ];
    settings.model.provider = "custom";
    settings.model.base_url = "http://localhost:11434/v1";
    settings.model.default = "Delta";
    mcpServers = {
      fastmail = { url = "https://api.fastmail.com/mcp"; auth = "oauth"; };
    };
    settings.web.search_backend = "searxng";
    addToSystemPackages = true;
    stateDir = config.users.users.mira.home;
    user = "mira";
    group = "hermes";
    createUser = false;
  };

  networking.firewall.allowedTCPPorts = [ (lib.toIntBase10 config.services.hermes-agent.environment.API_SERVER_PORT) ];

  users.groups.hermes = { };
  users.users.mira = {
    isNormalUser = true;
    home = "/home/mira";
    hashedPasswordFile = config.sops.secrets.mira-password.path;
    extraGroups = [ "hermes" ];
    shell = pkgs.bashInteractive;
    openssh = {
      authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIOsUvi/j/2Gs8QkZ5S0/bGsK/BhmU8n24eDFCc7GZx9 cardno:13_494_293"
      ];
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


