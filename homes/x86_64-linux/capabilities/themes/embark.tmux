# vim: set ft=tmux:
set -g status-interval 3
set-option -g status-position top
set-option -g pane-active-border-style "bg=black,fg=magenta"
set-option -g pane-border-style "fg=brightwhite"
set-option -g message-style "bg=green,fg=black"
set-option -g message-command-style "bg=green,fg=black"
set -g popup-border-style "fg=#585273"
set -g popup-border-lines "rounded"

# Status line
set -g status-style default
set -g status-right-length 80
set -g status-left-length 100
set -g window-status-separator ""
set -g status-bg "#100F23"
set -g status-fg "brightwhite"

#Bars ---------------------------------
set -g status-left "#[bg=black,fg=brightwhite] 󰇂  "

set -g status-right "#[bg=black,fg=brightwhite] #S | #[fg=brightwhite italics]󰲐 #H "

# Windows ------------------------------
set -g status-justify left

set -g window-status-format " #I | #W #[fg=magenta]#{?window_zoomed_flag,󰆞 ,}"
set -g window-status-current-format "#[fg=white,bg=black] #I | #W #[fg=magenta]#{?window_zoomed_flag,󰆞 ,}"
