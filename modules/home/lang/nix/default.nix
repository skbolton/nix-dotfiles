{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.delta.lang.nix;
in
{
  options.delta.lang.nix = with types; {
    enable = mkEnableOption "Nix Language support";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nixd
      nixpkgs-fmt
    ];

    xdg.configFile."nvim/lsp/nixd.lua".text = /* lua */ ''
      return {
        cmd = {'nixd'},
        filetypes = { 'nix' },
        root_markers = {'flake.nix', 'shell.nix'},
        settings = {
          nixd = {
            nixpkgs = {
              expr = "import <nixpkgs> { }",
             },
            formatting = { command = { "nixpkgs-fmt" } },
            options = {
              nixos = {
               expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.' .. vim.fn.hostname() .. '.options',
              },
              home_manager = {
                expr = '(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.' .. vim.fn.hostname() .. '.options.home-manager.users.type.getSubOptions []'
              }
            }
          }
        }
      }
    '';

    programs.neovim.extraLuaConfig = /* lua */ ''
      vim.lsp.enable('nixd')
    '';
  };
}
