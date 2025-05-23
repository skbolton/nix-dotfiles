{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.delta.zsh;
in
{
  options.delta.zsh = with types; {
    enable = mkEnableOption "ZSH";
  };

  config = {
    home.packages = with pkgs; [
      flyctl
    ];
    programs.zsh = {
      enable = cfg.enable;
      autosuggestion.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      historySubstringSearch.enable = true;
      autocd = true;
      cdpath = [ "." "$HOME" "$HOME/Public" "$HOME/Documents" "$HOME/Notes" ];
      defaultKeymap = "viins";
      dotDir = ".config/zsh";
      plugins = [
        { name = "fzf-tab"; src = "${pkgs.zsh-fzf-tab}/share/fzf-tab"; }
      ];
      shellGlobalAliases = {
        E = "| entr -c";
        F = "| fzf";
        R = "| rg";
        CCC = "| wl-copy";
        PPP = "wl-paste";
      };
      shellAliases = {
        t = "task";
        cat = "bat --paging=never";
        mv = "mv -iv";
        cp = "cp -iv";
        rm = "rm -v";
        v = "nvim";
        m = "iex -S mix";
        ms = "iex -S mix phx.server";
        mdg = "mix deps.get";
        mdc = "mix deps.clean --all";
        sys = "systemctl";
        sysu = "systemctl --user";
        reload = "source ~/.config/zsh/.zshrc";
      };
      history = {
        path = "${config.xdg.dataHome}/zsh/zsh_history";
        expireDuplicatesFirst = true;
        ignoreDups = true;
        extended = true;
        ignoreSpace = true;
      };
      envExtra = ''
        export MANPAGER="nvim +Man!"
        export PAGER=bat
        BLK="00" CHAR="00" DIR="0C" EXE="DE" REG="00" HLI="00" SLI="00" MIS="00" ORP="00" FIF="00" SOC="00" UNK="00"
        export NNN_FCOLORS="$BLK$CHAR$DIR$EXE$REG$HLI$SLI$MIS$ORP$FIF$SOC$UNK"
        export NNN_COLORS="6666"
        export NNN_OPTS=Hd
        export NNN_FIFO=/tmp/nnn.fifo
      '';

      initContent = mkMerge [
        (mkOrder 550 ''
          setopt AUTO_PUSHD           # Push the old directory onto the stack on cd
          setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack
          setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd
          setopt CORRECT              # Spelling Corrections
          setopt CDABLE_VARS          # Change directory to a path stored in a variable
          setopt EXTENDED_GLOB        # Use extended globbing syntax
          KEYTIMEOUT=5
        '')
        (mkOrder 1000 ''
          autoload -Uz edit-command-line
          zle -N edit-command-line
          bindkey -M viins '^f' edit-command-line
          bindkey -M vicmd '^i' edit-command-line

          source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
    
          ${pkgs.dwt1-shell-color-scripts}/bin/colorscript -e blocks1

          function w() {
            fd $1 | entr -c "''${@:2}"
          }

          function ew() {
            fd "\.exs?$" | entr -c "$@"
          }

          function take() {
            mkdir -p $1 && cd $1
          }

          function zvm_after_init() {
            zvm_bindkey viins '^R' fzf-history-widget
            bindkey -M viins '^f' edit-command-line
          }

          precmd() {
            precmd() {
              tput setaf 8 && printf '%.s─' $(seq 1 $(tput cols))
              echo
            }
          }
        '')
      ];
    };

    programs.starship = {
      enable = cfg.enable;
      settings.add_newline = false;
      enableZshIntegration = true;
    };
  };
}
