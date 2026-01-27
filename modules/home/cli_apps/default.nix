{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.delta.cli_apps;
in
{
  options.delta.cli_apps = with types; {
    enable = mkEnableOption "cli applications";
  };

  config = {
    home.packages = with pkgs; [
      unzip
      miller
      entr
      md-tangle
      dateutils
      devenv
    ];

    programs.jq.enable = cfg.enable;
    programs.fd.enable = cfg.enable;

    programs.ripgrep = {
      enable = cfg.enable;
      arguments = [
        "--colors=match:bg:yellow"
        "--colors=match:fg:black"
      ];
    };

    programs.bat.enable = cfg.enable;

    programs.nnn = {
      enable = cfg.enable;
      package = pkgs.nnn.override ({ withNerdIcons = true; extraMakeFlags = [ "O_NAMEFIRST=1" ]; });
      bookmarks = {
        d = "~/Documents";
        o = "~/Downloads";
      };
      plugins = {
        mappings = {
          p = "preview-tui";
        };
        src = (pkgs.fetchFromGitHub {
          owner = "jarun";
          repo = "nnn";
          rev = "9e95578c22bf76515a633723f6ec335469d4f000";
          sha256 = "sha256-XM88ROUexwl26feNRik8pMzOcpiF84bC3l3F4RQnG34=";
        }) + "/plugins";
      };
    };

    programs.direnv = {
      enable = cfg.enable;
      enableZshIntegration = true;
      stdlib = ''
        source_env_if_exists .envrc.private
      '';
    };

    programs.fzf = {
      enable = cfg.enable;
      enableZshIntegration = true;
      defaultCommand = "${pkgs.fd}/bin/fd --type f";
      fileWidgetCommand = "${pkgs.fd}/bin/fd --type f --hidden";
      fileWidgetOptions = [
        "--preview '${pkgs.bat}/bin/bat --color=always {}'"
        "--pointer ' '"
      ];
      changeDirWidgetCommand = "${pkgs.fd}/bin/fd --type d";
      changeDirWidgetOptions = [
        "--preview '${pkgs.eza}/bin/eza --tree --icons --color=always --level 3 --git-ignore {}'"
        "--pointer ' '"
      ];
      historyWidgetOptions = [ "--pointer ' '" ];
      defaultOptions = [ "--reverse" "--ansi" "--pointer '▌'" ];
    };

    programs.skim = {
      enable = cfg.enable;
      enableZshIntegration = false;
      defaultCommand = "${pkgs.fd}/bin/fd --type f --exclude '.git'";
      changeDirWidgetCommand = "${pkgs.fd}/bin/fd --type d";
      fileWidgetCommand = "${pkgs.fd}/bin/fd --type f";
      defaultOptions = [ "--reverse" "--ansi" ];
    };

    programs.eza = {
      enable = cfg.enable;
      icons = "auto";
      extraOptions = [ "--group-directories-first" "--header" ];
      git = true;
    };

    programs.btop = {
      enable = cfg.enable;
      settings = {
        vim_keys = true;
      };
    };
  };
}
