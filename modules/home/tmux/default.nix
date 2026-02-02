{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.delta.tmux;
in
{
  options.delta.tmux = with types; {
    enable = mkEnableOption "tmux";
    extraConfig = mkOption {
      type = lines;
      description = "Extra lines to add at the end of tmux config";
      default = '''';
    };
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      shellAliases = {
        mux = "${pkgs.tmux}/bin/tmux";
        muxa = "${pkgs.tmux}/bin/tmux a";
        muxk = "${pkgs.tmux}/bin/tmux kill-server";
      };
    };

    programs.git.ignores = [ ".steve-smug.yml" ];

    home.packages = [
      pkgs.unstable.smug
      pkgs.delta.rally
      pkgs.delta.tmux-file-paths
      pkgs.imagemagick
    ];

    programs.tmux = {
      enable = true;
      baseIndex = 1;
      escapeTime = 0;
      historyLimit = 10000;
      keyMode = "vi";
      mouse = true;

      plugins = with pkgs.tmuxPlugins; [
        vim-tmux-navigator
        {
          plugin = jump;
          extraConfig = ''
            set -g @jump-key '='
          '';
        }
        tmux-fzf
        {
          plugin = fuzzback;
          extraConfig = ''
            set -g @fuzzback-popup 1
            set -g @fuzzback-popup-size '90%'
            set -g @fuzzback-fzf-colors '${lib.strings.concatStringsSep "," (lib.attrsets.mapAttrsToList (name: value: name + ":" + value) config.programs.fzf.colors)}'
          '';
        }
      ];
      terminal = "tmux-256color";

      extraConfig = ''
        set -g default-command $SHELL
        set -g allow-passthrough on
        set -ga update-environment TERM
        set -ga update-environment TERM_PROGRAM
        set -gw xterm-keys on
        set -g focus-events on
        set -as terminal-features ',xterm*:RGB'
        set -g status-interval 5
        set set-clipboard on
        set -g pane-base-index 1
        set -g automatic-rename off
        set -g renumber-windows
        set -g clock-mode-style 24

        source ~/.config/tmux/bindings.tmux
        source "~/.config/tmux/statusline.tmux"

        ${cfg.extraConfig}
      '';
    };

    xdg.configFile."tmux/bindings.tmux".text = ''
      #######################################################################
      # General
      #######################################################################
      bind ! kill-server
      bind -n S-Up set-option status
      bind -n S-Down set-option status
      bind Escape copy-mode
      bind-key p paste-buffer
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi V send-keys -X select-line
      bind-key -T copy-mode-vi y send-keys -X copy-selection \; send-keys -X cancel
      bind-key -T copy-mode-vi C-y send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi Escape send-keys -X cancel
      bind-key C-r choose-buffer
    
      #######################################################################
      # Panes
      #######################################################################
      bind | split-window -h -l 33%
      bind - split-window -v -l 33%
      bind H resize-pane -L 10
      bind J resize-pane -D 10
      bind K resize-pane -U 10
      bind L resize-pane -R 10
      bind o kill-pane -a
    
      #######################################################################
      # Windows
      #######################################################################
      bind -n S-Left previous-window
      bind -n S-Right next-window
      bind h previous-window
      bind l next-window
      bind > display-popup -E -w 50% -h 50%
    
      #######################################################################
      # Clients
      #######################################################################
      bind j switch-client -p
      bind k switch-client -n
      bind BSpace switch-client -l
      bind C-d switch-client -t Delta
      bind C-h new-window -n  dijo
    
      #######################################################################
      # Tasks
      #######################################################################
      bind s display-popup -E -w 90% -h 90% ${pkgs.delta.rally}/bin/rally.sh
      bind C-l split-window -h -l 120 zk log
      bind C-h split-window -h -l 150 fman
    
      #######################################################################
      # Layers
      #######################################################################
      bind g switch-client -Ttable1
      bind -Ttable1 x split-window -h -l 100 \; send-keys '${pkgs.gh}/bin/gh pr checks' C-m
      bind -Ttable1 ? split-window -h -l 100 \; send-keys '${pkgs.gh}/bin/gh' C-m
      bind -Ttable1 ! split-window -h -l 100 '${pkgs.gh}/bin/gh pr view --web'
      bind -Ttable1 t split-window -h 'clickup.sh'

      bind t switch-client -Ttable2
      bind -Ttable2 t if "tmux display -p '#h' | grep -q niobe" "split-window -b -h -l 33% \; send ssh Space orlando@trinity.home.arpa Enter"
      bind -Ttable2 T if "tmux display -p '#h' | grep -q niobe" "split-window -b -h -l 33% \; send ssh Space orlando@trinity.home.arpa Enter task Enter" "send task Enter"
      bind -Ttable2 r split-window -b -h -l 33% \; if "tmux display -p '#h' | grep -q niobe" "send ssh Space orlando@trinity.home.arpa Enter \; send zk Space ei Enter" "send zk Space ei Enter"
      bind -Ttable2 l split-window -b -h -l 100 'cd ~/Documents/Notes && zk log'

      # WINDOW LAYER
      # keep the default w key available somewhere
      bind W choose-tree -Zw

      bind w switch-client -Ttable3
      bind -Ttable3 j split-window -v
      bind -Ttable3 k split-window -v -b
      bind -Ttable3 h split-window -h -b
      bind -Ttable3 l split-window -h

      bind -Ttable3 Left swap-pane -d -t '{left-of}'
      bind -Ttable3 Up swap-pane -d -t '{up-of}'
      bind -Ttable3 Right swap-pane -d -t'{right-of}'
      bind -Ttable3 Down swap-pane -d -t '{down-of}'
    '';

    xdg.configFile.smug = {
      source = ./smug;
      recursive = true;
    };
  };
}

