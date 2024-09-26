{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fava
    beancount
    # beancount-language-server
  ];

  systemd.user.services.fava = {
    Unit = {
      Description = "Start Fava Web GUI";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      ExecStart = "${pkgs.fava}/bin/fava /home/orlando/Ledger/2024/journal.beancount";
    };
  };

  # xdg.configFile."nvim/after/ftplugin/beancount.lua".text = /* lua */ ''
  #   local capabilities = require 'lsp_capabilities' ()
  #
  #   local executable = 'beancount-language-server'
  #
  #   if vim.fn.executable(executable) then
  #     -- NOTE: This has been a somewhat flaky language server to work with
  #     vim.lsp.start {
  #       name = 'beancountlsp',
  #       cmd = { executable, '--stdio' },
  #       capabilities = capabilities,
  #       root_dir = vim.fs.dirname(vim.fs.find('.git', { upward = true })[1]),
  #       init_options = {
  #         journal_file = vim.loop.os_homedir() .. "/Ledger/2024/journal.beancount"
  #       }
  #     }
  #   end
  # '';
}

