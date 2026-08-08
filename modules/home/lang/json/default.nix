{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.delta.lang.json;
in
{
  options.delta.lang.json = {
    enable = lib.mkEnableOption "json Language support";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ vscode-json-languageserver ];

    xdg.configFile."nvim/lsp/jsonls.lua".text = /* lua */ ''
      return {
        cmd = { 'vscode-json-language-server', '--stdio' },
        filetypes = { 'json', 'jsonc' },
        root_markers = { '.git'}
      }
    '';

    programs.neovim.initLua = /* lua */ ''
      vim.lsp.enable('jsonls')
    '';
  };
}
