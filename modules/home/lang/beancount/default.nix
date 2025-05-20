{ lib, config, pkgs, ... }:

with lib;
{
  config = mkIf config.delta.finance.enable {
    home.packages = with pkgs; [
      beancount-language-server
    ];

    xdg.configFile."nvim/after/ftplugin/beancount.lua".text = /* lua */ ''
      local capabilities = require 'lsp_capabilities'()

      vim.lsp.start {
        name = 'beancount',
        cmd = { 'beancount-language-server', '--stdio' },
        capabilities = capabilities,
        root_dir = vim.fs.dirname(vim.fs.find({'.git'}, { upward = true })[1]),
        init_options = {
          journal_file = os.getenv("HOME") .. "/Public/ledger/main.beancount"
        }
      }
    '';
  };
}

