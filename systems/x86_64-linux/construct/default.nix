# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./disks.nix
    ./hardware.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      trusted-users = [
        "root"
        "@wheel"
      ];
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

  sops.secrets.construct-password = {
    neededForUsers = true;
  };

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
    extraGroups = [
      "wheel"
      "docker"
    ];
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

  virtualisation.docker.enable = true;

  delta.llama-swap = {
    enable = true;
    listenAddress = "0.0.0.0";
    port = 11434;
    openFirewall = true;
    settings = {
      logLevel = "debug";
      healthCheckTimeout = 1500;
      includeAliasesInList = true;

      models."DeepSeek-V4.1-Flash" = {
        cmdStop = "${pkgs.docker}/bin/docker stop \${MODEL_ID}";
        cmd = ''
          ${pkgs.docker}/bin/docker run
            --rm --name ''${MODEL_ID}
            --ipc host
            --network host
            --init
            --security-opt seccomp=unconfined
            --device=nvidia.com/gpu=all
            --ulimit memlock=-1:-1
            --ulimit nofile=1048576:1048576
            --ulimit stack=67108864
            -v /models/:/root/models:ro
            -v ds41-kraken-cache:/cache
            -e MODEL=/root/models/DeepseekV4.1-Flash
            -e PORT=''${PORT}
            -e SERVED_MODEL_NAME=Delta
            -e DS41_ENGRAM_RAM_LAYERS=
            azallaza/ds41-kraken-tp3@sha256:c4c2de529da6d3762951e7f5c5b696866f20d740a5f16d9cdda0f13786352646
            --served-model-name Delta
            --enable-force-include-usage
            --enable-prompt-tokens-details
            --enable-per-request-metrics
        '';
        aliases = [ "Delta" ];
      };

      models."GLM-5.3-Flash" = {
        cmdStop = "${pkgs.docker}/bin/docker stop \${MODEL_ID}";
        cmd = ''
          ${pkgs.docker}/bin/docker run
            --rm --name ''${MODEL_ID}
            --shm-size 64g
            --ipc host
            --network host
            --init
            --cpuset-cpus 8-47
            --device=nvidia.com/gpu=all
            --ulimit memlock=-1:-1
            --ulimit nofile=1048576:1048576
            --ulimit stack=67108864
            -v /models/:/root/models:ro
            -e HF_HUB_OFFLINE=1
            -e TRANSFORMERS_OFFLINE=1
            -e VLLM_NO_USAGE_STATS=1
            -e VLLM_TP3_PCIE_DCP=1
            -e VLLM_B12X_BF16_GEMV=1
            -e VLLM_GLM53_MXFP8_GEMV=1
            -e VLLM_PCIE_ONESHOT_ALLREDUCE_MAX_SIZE=1MB
            -e VLLM_GLM53_FP8_DENSE=1
            -e VLLM_GLM53_FP8_LM_HEAD=1
            -e VLLM_GLM53_FP8_FFN=1
            -e VLLM_GLM53_FP8_MTP=1
            -e VLLM_GLM53_FP8_PREFILL=w8a8
            -e VLLM_GLM53_L2_PREFETCH_BUDGET_A_MB=10
            -e VLLM_GLM53_L2_PREFETCH_BUDGET_B_MB=25
            -e VLLM_GLM53_L2_PREFETCH_BUDGET_C_MB=7.5
            -e VLLM_GLM53_L2_PREFETCH_BUDGET_A_MLA_MB=18
            -e VLLM_GLM53_L2_PREFETCH_PERSIST_MB=0
            -e VLLM_GLM53_L2_PREFETCH_A_NEXT_MB=0
            -e VLLM_GLM53_CSF_RESIDENT_SCALES=1
            -e VLLM_B12X_MOE_FP4_FORCE_A16=0
            -e VLLM_GLM53_TP3_MOE_TP=2112
            -e VLLM_GLM53_KDA_NO_COPY=0
            -e VLLM_GLM53_FP8_LM_HEAD_DROP_BF16=1
            -e VLLM_SHARE_PYNCCL_COMMS=1
            -e GLM53_TP3_REQUIRE_RUNTIME_PROOF=1
            --entrypoint /usr/local/bin/lil-entrypoint
            azallaza/glm53-kraken-tp3@sha256:358c9b64ffaf7c7d45e9447e385b7b79858165c9d90797d4acd4b90425655c24
            --profile glm53-flash
            --hardware rtx-pro-6000-pcie
            --checkpoint csf
            --model /root/models/GLM-5.3-Flash/NVFP4-CSF
            --mode mtp
            --tensor-parallel-size 3
            --decode-context-parallel-size 1
            --moe-backend b12x
            --max-num-seqs 8
            --max-model-len 1048576
            --gpu-memory-utilization 0.95
            --max-num-batched-tokens 4096
            --max-parallel-prefills auto
            --max-cudagraph-capture-size 128
            --cache-mode vram
            --enable-flashinfer-autotune
            --served-model-name Delta
            --default-chat-template-kwargs '{"reasoning_effort":"high"}'
            --override-generation-config '{"temperature":1.0,"top_p":0.95}'
            --mm-encoder-tp-mode data
            --additional-config '{"glm53_kda_decode_backend":"b12x","kda_prefill_backend":"flashkda"}'
            --kv-cache-memory-bytes 30415841280
            --cudagraph-capture-sizes 1 2 4 8 12 16 20 24 28 32 40 48 56 64 72 80 88 96 104 112 120 128
            --host 0.0.0.0
            --port ''${PORT}
        '';
        # aliases = [ "Delta" ];
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
