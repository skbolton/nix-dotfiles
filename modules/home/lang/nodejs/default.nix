{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.delta.lang.nodejs;
in
{
  options.delta.lang.nodejs = with types; {
    enable = mkEnableOption "NodeJS Language support";
  };


  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nodejs_20
      typescript-language-server
    ];

    xdg.configFile."nvim/lsp/ts_ls.lua".text = /* lua */ ''
      return {
        cmd = { 'typescript-language-server', '--stdio' },
        filetypes = {
          'javascript',
          'javascriptreact',
          'javascript.jsx',
          'typescript',
          'typescriptreact',
          'typescript.tsx',
        },
        root_markers = {'tsconfig.json', 'package.json', 'jsconfig.json', '.git'},
      }
    '';

    programs.neovim.extraLuaConfig = /* lua */ ''
      vim.lsp.enable('ts_ls')
    '';
  };
}
