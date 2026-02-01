{
  description = "Stephen Bolton's Dotfiles";

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
    # substituters = [
    #   "https://cache.nixos.org"
    # ];
    #
    # extraSubstituters = [
    #   "https://nix-community.cachix.org"
    # ];
    #
    # extra-trusted-public-keys = [
    #   "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    # ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };

    disko = {
      url = "github:nix-community/disko";
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
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    embark-bat-theme = {
      url = "github:embark-theme/bat";
      flake = false;
    };

    embark-vim = {
      url = "github:embark-theme/vim";
      flake = false;
    };

    dev-null-theme = {
      url = "github:skbolton/dev-null.nvim";
      flake = false;
    };

    spelunk-nvim = {
      url = "github:EvWilson/spelunk.nvim";
      flake = false;
    };

    awesome-neovim-plugins.url = "github:m15a/flake-awesome-neovim-plugins";

    neorg-overlay.url = "github:nvim-neorg/nixpkgs-neorg-overlay";

    lz-n = {
      url = "github:nvim-neorocks/lz.n";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    llama-cpp.url = "github:ggml-org/llama.cpp";

    opencode.url = "github:anomalyco/opencode";

    zsh-almostontop = {
      url = "github:Valiev/almostontop";
      flake = false;
    };
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;

      src = ./.;

      snowfall.namespace = "delta";

      channels-config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "electron-32.3.3"
        ];
      };

      overlays = with inputs; [
        neorg-overlay.overlays.default
        awesome-neovim-plugins.overlays.default
      ];

      homes.modules = with inputs; [
        sops-nix.homeManagerModules.sops
      ];

      systems.modules.nixos = with inputs; [
        stylix.nixosModules.stylix
        sops-nix.nixosModules.sops
        disko.nixosModules.disko
      ];

      systems.modules.darwin = with inputs; [
        stylix.darwinModules.stylix
        nix-homebrew.darwinModules.nix-homebrew
      ];
    };
}
