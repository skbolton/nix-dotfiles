{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.delta.lang.go;
in
{
  options.delta.lang.go = with types; {
    enable = mkEnableOption "Go Language support";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      go
      gopls
    ];

    xdg.configFile."nvim/lsp/gopls.lua".text = /* lua */ ''
      return {
        cmd = { 'gopls' },
        filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
        root_markers = { 'go.mod', 'go.sum', '.git' },
        settings = {
          gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            analyses = {
              unusedparams = true,
            },
          }
        }
      }
    '';

    programs.neovim.extraLuaConfig = /* lua */ ''
      vim.lsp.enable('gopls')
    '';
  };
}
