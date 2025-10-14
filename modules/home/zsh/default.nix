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
      dirHashes = {
        co = "$HOME/.config";
        st = "$HOME/.local/state";
        sh = "$HOME/.local/share";
        ca = "$HOME/.cache";
        ni = "/nix/store";
      };
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

          # use tmux popup
          zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
          # popup minimum size
          zstyle ':fzf-tab:*' popup-min-size 50 8
          # disable sort when completing `git checkout`
          zstyle ':completion:*:git-checkout:*' sort false
          # set descriptions format to enable group support
          # NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
          zstyle ':completion:*:descriptions' format '[%d]'
          # set list-colors to enable filename colorizing
          zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
          # force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
          zstyle ':completion:*' menu no
          # preview directory's content with eza when completing cd
          zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
          # To make fzf-tab follow FZF_DEFAULT_OPTS.
          # NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
          zstyle ':fzf-tab:*' use-fzf-default-opts yes
          # switch group using `<` and `>`
          zstyle ':fzf-tab:*' switch-group '<' '>'
        '')
        (mkOrder 1000 ''
          autoload -Uz edit-command-line
          zle -N edit-command-line
          bindkey -M viins '^f' edit-command-line
          bindkey -M vicmd '^i' edit-command-line

          source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
    
          tput setaf ''${$(( ( RANDOM % 6 ) + 1 ))} && printf "%*s\n" $(((''${#title}+$COLUMNS)/2)) "EYES UP, GUARDIAN"

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
              echo
            }
          }

          source "${pkgs.zsh-autopair}/share/zsh/zsh-autopair/autopair.zsh";
          autopair-init
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
