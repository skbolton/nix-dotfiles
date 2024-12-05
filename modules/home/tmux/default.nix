{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.delta.tmux;
in
{
  options.delta.tmux = with types; {
    enable = mkEnableOption "tmux";
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
      pkgs.smug
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
          plugin = tmux-thumbs;
          extraConfig = ''
            set -g @thumbs-key '='
            set -g @thumbs-reverse enabled
            set -g @thumbs-hint-bg-color yellow
            set -g @thumbs-hint-fg-color black
            set -g @thumbs-contrast 1
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
        set -g allow-passthrough on
        set -ga update-environment TERM
        set -ga update-environment TERM_PROGRAM
        set -gw xterm-keys on
        set -g focus-events on
        set -as terminal-features ',xterm*:RGB'
        set -g status-interval 5
        set set-clipboard on
        set -g pane-base-index 1
        set -g pane-border-indicators both
        set -g automatic-rename off
        set -g renumber-windows
        set -g clock-mode-style 24

        source ~/.config/tmux/bindings.tmux
        source "~/.config/tmux/statusline.tmux"
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
      bind-key -T copy-mode-vi y send-keys -X copy-selection
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
      bind s display-popup -E -w 80% -h 70% ${pkgs.delta.rally}/bin/rally.sh
      bind S display-popup -E 'tmux switch-client -t "$(tmux list-sessions -F "#{session_name}" | ${pkgs.fzf}/bin/fzf)"'
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
    '';

    xdg.configFile.smug = {
      source = ./smug;
      recursive = true;
    };
  };
}

