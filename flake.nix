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

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    embark-vim = {
      url = "github:embark-theme/vim";
      flake = false;
    };

    neorg-overlay.url = "github:nvim-neorg/nixpkgs-neorg-overlay";

  };

  # `outputs` are all the build result of the flake.
  # A flake can have many use cases and different types of outputs.
  # parameters in `outputs` are defined in `inputs` and can be referenced by their names.
  # However, `self` is an exception, This special parameter points to the `outputs` itself (self-reference)
  # The `@` syntax here is used to alias the attribute set of the inputs's parameter, making it convenient to use inside the function.
  # outputs = { self, nixpkgs, home-manager, NixOS-WSL, ... }@inputs:
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

      homes.modules = [ ];

      systems.modules = with inputs; {
        nixos = [
        ];

        trinity = [
          sops-nix.nixosModules.sops
        ];

        neo = [
          sops-nix.nixosModules.sops
        ];

        weasel = [
          NixOS-WSL.nixosModules.wsl
        ];
      };
    };
  # let
  #   inherit (self) outputs;
  #   unstable = import inputs.nixpkgs-unstable { system = "x86_64-linux"; config.allowUnfree = true; };
  # in
  # {
  #   nixosModules = import ./modules/nixos;
  #   nixosConfigurations = {
  #     trinity = nixpkgs.lib.nixosSystem {
  #       modules = [
  #         ./hosts/trinity
  #         { programs.hyprland.enable = true; }
  #         {
  #           home-manager.useGlobalPkgs = true;
  #           home-manager.useUserPackages = true;
  #           home-manager.extraSpecialArgs = { inherit inputs; };
  #           home-manager.users.orlando = import ./home/trinity;
  #         }
  #       ];
  #     };
  #     neo = nixpkgs.lib.nixosSystem {
  #       modules = [
  #         ./hosts/neo
  #         { programs.hyprland.enable = true; }
  #         {
  #           home-manager.useGlobalPkgs = true;
  #           home-manager.useUserPackages = true;
  #           home-manager.extraSpecialArgs = { inherit inputs; };
  #           home-manager.users.orlando = import ./home/neo;
  #         }
  #       ];
  #     };
  #
  #     weasel = nixpkgs.lib.nixosSystem {
  #       modules = [
  #         {
  #           nix.registry.nixpkgs.flake = nixpkgs;
  #         }
  #         ./hosts/weasel
  #         {
  #           home-manager.useGlobalPkgs = true;
  #           home-manager.useUserPackages = true;
  #           home-manager.extraSpecialArgs = { inherit inputs; };
  #           home-manager.users.orlando = import ./home/weasel;
  #         }
  #       ];
  #     };
  #   };
  # };
}
