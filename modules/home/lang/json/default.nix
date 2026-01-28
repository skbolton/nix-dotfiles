{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.delta.lang.json;
in
{
  options.delta.lang.json = with types; {
    enable = mkEnableOption "json Language support";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ vscode-json-languageserver ];

    xdg.configFile."nvim/lsp/jsonls.lua".text = /* lua */ ''
      return {
        cmd = { 'vscode-json-language-server', '--stdio' },
        filetypes = { 'json', 'jsonc' },
        root_markers = { '.git'}
      }
    '';

    programs.neovim.extraLuaConfig = /* lua */ ''
      vim.lsp.enable('jsonls')
    '';
  };
}

