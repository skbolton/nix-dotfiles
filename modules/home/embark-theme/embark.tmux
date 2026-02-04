# vim: set ft=tmux:
set -g status-interval 3
set-option -g status-position bottom
set-option -g pane-border-style "fg=#3E3859"
set-option -g pane-active-border-style "fg=#3E3859"
set-option -g pane-border-lines "single"
set-option -g pane-border-indicators "off"
set-option -g message-style "bg=green,fg=black"
set-option -g message-command-style "bg=green,fg=black"
set -g popup-border-style "fg=#3E3859"
set -g popup-border-lines "rounded"

# Status line
set -g status-style default
set -g status-right-length 80
set -g status-left-length 100
set -g window-status-separator ""
set -g status-bg "#19172C"
set -g status-fg "brightwhite"

#Bars ---------------------------------
set -g status-left "#[bg=#2D2B40]  #S #[fg=#2D2B40,bg=#19172C]"
set -g status-left-style "fg=brightwhite"

set -g status-right "#[fg=#2D2B40,bg=#19172C]#[fg=brightwhite,bg=#2D2B40] %Y-%m-%d | %H:%M | #[italics]󰲐 #H "

# Windows ------------------------------
set -g status-justify left

set -g window-status-separator ""
set -g window-status-format "#[bg=#19172C,fg=#2D2B40]#[bg=#2D2B40,fg=brightwhite] #W #[fg=#2D2B40,bg=#19172C]"
set -g window-status-current-format "#[bg=#19172C]#{?window_zoomed_flag,#[fg=brightmagenta],#[fg=brightcyan]}#[fg=black]#{?window_zoomed_flag,#[bg=brightmagenta],#[bg=brightcyan]} #W #[bg=#19172C]#{?window_zoomed_flag,#[fg=brightmagenta],#[fg=brightcyan]}"
set -g window-status-bell-style "bg=red"
