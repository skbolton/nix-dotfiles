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
      nil
      nixpkgs-fmt
    ];

    xdg.configFile."nvim/lsp/nil_ls.lua".text = /* lua */ ''
      return {
        cmd = {'nil'},
        filetypes = { 'nix' },
        root_markers = {'flake.nix', 'shell.nix'},
        settings = {
          ["nil"] = {
            formatting = { command = { "nixpkgs-fmt" } },
            nix = { flake = { autoArchive = true } }
          }
        }
      }
    '';

    programs.neovim.extraLuaConfig = /* lua */ ''
      vim.lsp.enable('nil_ls')
    '';
  };
}
