# vim: set ft=tmux:
set -g status-interval 3
set-option -g status-position bottom
set-option -g pane-border-style "fg=#1B1B1B"
set-option -g pane-active-border-style "fg=#1B1B1B"
set-option -g pane-border-lines "single"
set-option -g pane-border-indicators "off"
set-option -g message-style "bg=green,fg=black"
set-option -g message-command-style "bg=green,fg=black"
set -g popup-border-style "fg=#1B1B1B"
set -g popup-border-lines "rounded"

# Status line
set -g status-style default
set -g status-right-length 80
set -g status-left-length 100
set -g window-status-separator ""
set -g status-bg "#161616"
set -g status-fg "brightwhite"

#Bars ---------------------------------
set -g status-left " 󰇂  "
set -g status-left-style "bg=black,fg=brightwhite"

set -g status-right "#[bg=black,fg=brightwhite]  #S | #[fg=brightwhite italics]󰲐 #H "

# Windows ------------------------------
set -g status-justify left

set -g window-status-format " #I | #{?window_zoomed_flag,#[fg=magenta],}#W"
set -g window-status-current-format "#[fg=white,bg=black] #I | #{?window_zoomed_flag,#[fg=magenta],}#W"
set -g window-status-bell-style "bg=red"
