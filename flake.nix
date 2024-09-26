{
  description = "Stephen Bolton's Dotfiles";

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://cache.nixos.org"
    ];

    extraSubstituters = [
      "https://nix-community.cachix.org"
    ];

    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    NixOS-WSL = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    embark-vim = {
      url = "github:embark-theme/vim";
      flake = false;
    };

    neorg-overlay.url = "github:nvim-neorg/nixpkgs-neorg-overlay";
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;

      src = ./.;

      snowfall.namespace = "delta";

      channels-config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "electron-27.3.11"
        ];
      };

      overlays = with inputs; [
        neorg-overlay.overlays.default
      ];

      systems.hosts.weasel.modules = with inputs; [
        NixOS-WSL.nixosModules.wsl
      ];

      systems.modules.nixos = with inputs; [
        sops-nix.nixosModules.sops
      ];
    };
}
