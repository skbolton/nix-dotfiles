{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.delta.lang.bash;
in
{
  options.delta.lang.bash = {
    enable = lib.mkEnableOption "bash Language support";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.bash-language-server ];

    xdg.configFile."nvim/lsp/bashls.lua".text = /* lua */ ''
      return {
        cmd = { 'bash-language-server', 'start' },
        filetypes = { 'bash', 'sh', 'bats' },
        root_markers = { '.git' },
        settings = {
          bashIde = {
            globPattern = '*@(.sh|.inc|.bash|.command|.bats)',
          },
        },
      }
    '';

    programs.neovim.initLua = /* lua */ ''
      vim.filetype.add({
        pattern = {
          ['%.bats$'] = 'bash',
        },
      })

      vim.lsp.enable('bashls')
    '';
  };
}
