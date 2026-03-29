# vim: set ft=tmux:
set -g status-interval 3
set-option -g status-position bottom
set-option -g pane-border-style "fg=#122d42"
set-option -g pane-active-border-style "fg=#122d42"
set-option -g pane-border-lines "single"
set-option -g pane-border-indicators "off"
set-option -g message-style "bg=green,fg=black"
set-option -g message-command-style "bg=green,fg=black"
set -g popup-border-style "fg=#5f7e97"
set -g popup-border-lines "rounded"

# Status line
set -g status-style default
set -g status-right-length 80
set -g status-left-length 100
set -g window-status-separator ""
set -g status-bg "#011627"
set -g status-fg "#80A4C2"

#Bars ---------------------------------
set -g status-left "#[fg=#122d42,bg=#011627]#[fg=#80A4C2,bg=#122d42]  #S #[fg=#122d42,bg=#011627]"
set -g status-left-style "fg=#80A4C2"

set -g status-right "#[fg=#122d42,bg=#011627]#[fg=#80A4C2,bg=#122d42] %Y-%m-%d | %H:%M | #[italics]󰲐 #H #[fg=#122d42,bg=#011627]"

# Windows ------------------------------
set -g status-justify left

set -g window-status-separator ""
set -g window-status-format "#{?window_zoomed_flag,#[bg=#011627#,fg=#c792ea]#[bg=#c792ea#,fg=black] #{?pane_synchronized,#W  ,#W} #[fg=#c792ea#,bg=#011627],#[bg=#011627#,fg=#122d42]#[bg=#122d42#,fg=#80A4C2] #W #[fg=#122d42#,bg=#011627]}"
set -g window-status-current-format "#[bg=#011627]#{?window_zoomed_flag,#[fg=#c792ea],#[fg=#7fdbca]}#[fg=black]#{?window_zoomed_flag,#[bg=#c792ea],#[bg=#7fdbca]} #{?pane_synchronized,#W  ,#W} #[bg=#011627]#{?window_zoomed_flag,#[fg=#c792ea],#[fg=#7fdbca]}"
set -g window-status-bell-style "bg=red"
