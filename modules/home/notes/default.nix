{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.delta.notes;
in
{
  options.delta.notes = {
    enable = lib.mkEnableOption "Notes";
    notebook_dir = lib.mkOption {
      type = lib.types.str;
      description = "Primary nootbook root";
      default = "$HOME/Notes";
      example = "$HOME/Notes";
    };
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      JOURNALS = "$HOME/Documents/Logbook/Journal";
      ZK_NOTEBOOK_DIR = cfg.notebook_dir;
    };

    home.packages = with pkgs; [
      zk
      delta.qke
      delta.dsearch
      delta.weekp
      delta.dweek
      delta.dyear
      delta.dmonth
      delta.cosma
      unstable.vimPlugins.diagram-nvim
      unstable.vimPlugins.image-nvim
      mermaid-cli
    ];

    programs.neovim.extraLuaPackages = luaPkgs: with luaPkgs; [ neorg-interim-ls ];

    programs.neovim.plugins = with pkgs; [
      {
        plugin = vimPlugins.image-nvim;
        type = "lua";
        optional = true;
        config = /* lua */ ''
          require 'lz.n'.load {
            "image.nvim",
            filetypes = {"neorg", "markdown"},
            after = function()
              require 'image'.setup {}
            end
          }
        '';
      }
      {
        plugin = vimPlugins.diagram-nvim;
        type = "lua";
        optional = true;
        config = /* lua */ ''
          require 'lz.n'.load {
            "diagram.nvim",
            filetypes = {"neorg", "markdown"},
            after = function()
              require 'diagram'.setup {
                events = {
                  render_buffer = {'InsertLeave', 'BufEnter', 'BufWinEnter', 'FocusGained', 'TextChanged' },
                  clear_buffer = { 'FocusLost' }
                }
              }
            end
          }
        '';
      }
    ];

    xdg.configFile."zk/config.toml".source = ./zk.toml;
  };

}
