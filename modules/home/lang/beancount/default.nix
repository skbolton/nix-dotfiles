{ lib, config, pkgs, ... }:

with lib;
{
  config = mkIf config.delta.finance.enable {
    home.packages = with pkgs; [
      beancount-language-server
    ];

    xdg.configFile."nvim/lsp/beancount_ls.lua".text = /* lua */ ''
      return {
        cmd = { 'beancount-language-server', '--stdio' },
        filetypes = { 'beancount', 'bean' },
        root_markers = { '.git' },
        init_options = {
          journal_file = os.getenv("HOME") .. "/Public/ledger/main.beancount"
        }
      }
    '';

    programs.neovim.extraLuaConfig = /* lua */ ''
      vim.lsp.enable('beancount_ls')
    '';
  };
}

