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

  # This is the standard format for flake.nix. `inputs` are the dependencies of the flake,
  # and `outputs` function will return all the build results of the flake.
  # Each item in `inputs` will be passed as a parameter to the `outputs` function after being pulled and built.
  inputs = {
    # There are many ways to reference flake inputs. The most widely used is github:owner/name/reference,
    # which represents the GitHub repository URL + branch/commit-id/tag.

    # Official NixOS package source, using nixos-unstable branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    NixOS-WSL = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
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
  };

  # `outputs` are all the build result of the flake.
  # A flake can have many use cases and different types of outputs.
  # parameters in `outputs` are defined in `inputs` and can be referenced by their names.
  # However, `self` is an exception, This special parameter points to the `outputs` itself (self-reference)
  # The `@` syntax here is used to alias the attribute set of the inputs's parameter, making it convenient to use inside the function.
  outputs = { self, nixpkgs, home-manager, NixOS-WSL, ... }@inputs:
    let
      inherit (self) outputs;
    in
    {
      nixosModules = import ./modules/nixos;
      nixosConfigurations = {
        # By default, NixOS will try to refer the nixosConfiguration with its hostname.
        # so the system named `nixos-test` will use this configuration.
        # However, the configuration name can also be specified using `sudo nixos-rebuild switch --flake /path/to/flakes/directory#<name>`.
        # The `nixpkgs.lib.nixosSystem` function is used to build this configuration, the following attribute set is its parameter.
        # Run `sudo nixos-rebuild switch --flake .#nixos-test` in the flake's directory to deploy this configuration on any NixOS system
        trinity = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          # The Nix module system can modularize configuration, improving the maintainability of configuration.
          #
          # Each parameter in the `modules` is a Nix Module, and there is a partial introduction to it in the nixpkgs manual:
          #    <https://nixos.org/manual/nixpkgs/unstable/#module-system-introduction>
          # It is said to be partial because the documentation is not complete, only some simple introductions
          #    (such is the current state of Nix documentation...)
          # A Nix Module can be an attribute set, or a function that returns an attribute set.
          # If a Module is a function, this function can only have the following parameters:
          #
          #  lib:     the nixpkgs function library, which provides many useful functions for operating Nix expressions
          #            https://nixos.org/manual/nixpkgs/stable/#id-1.4
          #  config:  all config options of the current flake
          #  options: all options defined in all NixOS Modules in the current flake
          #  pkgs:   a collection of all packages defined in nixpkgs.
          #           you can assume its default value is `nixpkgs.legacyPackages."${system}"` for now.
          #           can be customed by `nixpkgs.pkgs` option
          #  modulesPath: the default path of nixpkgs's builtin modules folder,
          #               used to import some extra modules from nixpkgs.
          #               this parameter is rarely used, you can ignore it for now.
          #
          # Only these parameters can be passed by default.
          # If you need to pass other parameters, you must use `specialArgs` by uncomment the following line
          specialArgs = { inherit inputs outputs; }; # pass custom arguments into sub module.
          modules = [
            ./hosts/sops.nix
            ./hosts/trinity
            { programs.hyprland.enable = true; }
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.orlando = import ./home/trinity;
            }
          ];
        };
        neo = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          # The Nix module system can modularize configuration, improving the maintainability of configuration.
          #
          # Each parameter in the `modules` is a Nix Module, and there is a partial introduction to it in the nixpkgs manual:
          #    <https://nixos.org/manual/nixpkgs/unstable/#module-system-introduction>
          # It is said to be partial because the documentation is not complete, only some simple introductions
          #    (such is the current state of Nix documentation...)
          # A Nix Module can be an attribute set, or a function that returns an attribute set.
          # If a Module is a function, this function can only have the following parameters:
          #
          #  lib:     the nixpkgs function library, which provides many useful functions for operating Nix expressions
          #            https://nixos.org/manual/nixpkgs/stable/#id-1.4
          #  config:  all config options of the current flake
          #  options: all options defined in all NixOS Modules in the current flake
          #  pkgs:   a collection of all packages defined in nixpkgs.
          #           you can assume its default value is `nixpkgs.legacyPackages."${system}"` for now.
          #           can be customed by `nixpkgs.pkgs` option
          #  modulesPath: the default path of nixpkgs's builtin modules folder,
          #               used to import some extra modules from nixpkgs.
          #               this parameter is rarely used, you can ignore it for now.
          #
          # Only these parameters can be passed by default.
          # If you need to pass other parameters, you must use `specialArgs` by uncomment the following line
          specialArgs = { inherit inputs outputs; }; # pass custom arguments into sub module.
          modules = [
            ./hosts/sops.nix
            ./hosts/neo
            { programs.hyprland.enable = true; }
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.orlando = import ./home/neo;
            }
          ];
        };

        weasel = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs; };
          modules = [
            {
              nix.registry.nixpkgs.flake = nixpkgs;
            }
            ./hosts/sops.nix
            ./hosts/weasel
            NixOS-WSL.nixosModules.wsl
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.orlando = import ./home/weasel;
            }
          ];
        };
      };
    };
}
