{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nodejs_20
  ];

  xdg.configFile."nvim/after/ftplugin/javascript.lua".text = ''
    local capabilities = require 'lsp_capabilities'()

    vim.lsp.start {
      name = 'tsserver',
      cmd = { 'typescript-language-server', '--stdio' },
      capabilities = capabilities,
      root_dir = vim.fs.dirname(vim.fs.find({'tsconfig.json', 'package.json', 'jsconfig.json', '.git'}, { upward = true })[1])
    }
  '';

  xdg.configFile."nvim/after/ftplugin/typescript.lua".text = ''
    local capabilities = require 'lsp_capabilities'()

    vim.lsp.start {
      name = 'tsserver',
      cmd = { 'typescript-language-server', '--stdio' },
      capabilities = capabilities,
      root_dir = vim.fs.dirname(vim.fs.find({'tsconfig.json', 'package.json', 'jsconfig.json', '.git'}, { upward = true })[1])
    }
  '';
}
