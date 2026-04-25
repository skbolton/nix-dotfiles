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
            --device=nvidia.com/gpu=all
            voipmonitor/sglang:cu130
            python -m sglang.launch_server  
              --sleep-on-idle 
              --model-path /mnt/data/models/MiniMax-M2.7/NVFP4
              --served-model-name MiniMax-M2.7     
              --reasoning-parser minimax
              --tool-call-parser minimax-m2     
              --tp 2  
              --enable-torch-compile  
              --trust-remote-code
              --chunked-prefill-size 4096
              --quantization modelopt_fp4     
              --cuda-graph-max-bs 4
              --kv-cache-dtype fp8_e4m3
              --moe-runner-backend b12x  
              --fp4-gemm-backend b12x         
              --attention-backend flashinfer
              --mem-fraction-static 0.92                            
              --host 0.0.0.0 --port 5000
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


