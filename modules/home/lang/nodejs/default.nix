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
    ];

    xdg.configFile."nvim/after/ftplugin/javascript.lua".text = /* lua */ ''
      local capabilities = require 'lsp_capabilities'()

      vim.lsp.start {
        name = 'tsserver',
        cmd = { 'typescript-language-server', '--stdio' },
        capabilities = capabilities,
        root_dir = vim.fs.dirname(vim.fs.find({'tsconfig.json', 'package.json', 'jsconfig.json', '.git'}, { upward = true })[1])
      }
    '';

    xdg.configFile."nvim/after/ftplugin/typescript.lua".text = /* lua */ ''
      local capabilities = require 'lsp_capabilities'()

      vim.lsp.start {
        name = 'tsserver',
        cmd = { 'typescript-language-server', '--stdio' },
        capabilities = capabilities,
        root_dir = vim.fs.dirname(vim.fs.find({'tsconfig.json', 'package.json', 'jsconfig.json', '.git'}, { upward = true })[1])
      }
    '';
  };
}
