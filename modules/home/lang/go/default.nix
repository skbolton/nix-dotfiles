{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.delta.lang.go;
in
{
  options.delta.lang.go = {
    enable = lib.mkEnableOption "Go Language support";
  };

  config = lib.mkIf cfg.enable {
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
            gofumpt = true,
            completeUnimported = true,
            usePlaceholders = true,
            analyses = {
              unusedparams = true,
            },
          }
        }
      }
    '';

    programs.neovim.initLua = /* lua */ ''
      vim.lsp.enable('gopls')
    '';
  };
}
