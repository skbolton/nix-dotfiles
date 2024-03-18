# vim: set ft=tmux:
set -g status-interval 3
set-option -g status-position top
set-option -g pane-active-border-style "fg=#795DA3"
set-option -g pane-border-style "fg=#E0E0E0"
set-option -g message-style "bg=#CA1243,fg=#FFFFFF"
set-option -g message-command-style "bg=#CA1243,fg=#FFFFFF"

# Status line
set -g status-style default
set -g status-right-length 80
set -g status-left-length 100
set -g window-status-separator "  "
set -g status-bg "default"

#Bars ---------------------------------
set -g status-left "#[fg=#795DA3]#S #[fg=#969896]⎥ "

set -g status-right "#[fg=#969896] #[push-default]%Y-%m-%d#[fg=#969896] ⎥ #[fg=default]%I:%M #[fg=#969896]⎥ #[fg=#795DA3 italics]@#H"

# Windows ------------------------------
set -g status-justify centre

set -g window-status-format "#[fg=#969896]#{?window_zoomed_flag,▪#W,#W}"
set -g window-status-current-format "#[fg=#CA1243]#{?window_zoomed_flag,▪#W,#W}"
