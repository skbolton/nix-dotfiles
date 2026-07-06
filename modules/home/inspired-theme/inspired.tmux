# vim: set ft=tmux:
set -g status-interval 3
set-option -g status-position bottom
set-option -g pane-border-style "fg=#E0E0E0"
set-option -g pane-active-border-style "fg=#E0E0E0"
set-option -g pane-border-lines "single"
set-option -g pane-border-indicators "off"
set-option -g popup-border-style "fg=#E0E0E0"
set-option -g popup-border-lines "rounded"
set-option -g message-style "bg=#CA1243,fg=#FFFFFF"
set-option -g message-command-style "bg=#CA1243,fg=#FFFFFF"
set-option -g popup-border-lines single

# Status line
set -g status-style default
set -g status-right-length 80
set -g status-left-length 100
set -g window-status-separator "  "
set -g status-bg "default"

#Bars ---------------------------------
set -g status-left "#[fg=#EAEAEA,bg=#FFFFFF]#[fg=#3E3E3E,bg=#EAEAEA]  #S #[fg=#EAEAEA,bg=#FFFFFF]"
set -g status-left-style "fg=#3E3E3E"

set -g status-right "#[fg=#EAEAEA,bg=#FFFFFF]#[fg=#3E3E3E,bg=#EAEAEA] %Y-%m-%d | %H:%M | #[italics]󰲐 #H #[fg=#EAEAEA,bg=#FFFFFF]"

# Windows ------------------------------
set -g status-justify left

set -g window-status-separator ""
set -g window-status-format "#{?window_zoomed_flag,#[bg=#FFFFFF#,fg=#795DA3]#[bg=#795DA3#,fg=black] #{?pane_synchronized,#W  ,#W} #[fg=#795DA3#,bg=#FFFFFF],#[bg=#FFFFFF#,fg=#EAEAEA]#[bg=#EAEAEA#,fg=#3E3E3E] #W #[fg=#EAEAEA#,bg=#FFFFFF]}"
# set -g window-status-format "#{?window_zoomed_flag,#[bg=#011627#,fg=#c792ea]#[bg=#c792ea#,fg=black] #{?pane_synchronized,#W  ,#W} #[fg=#c792ea#,bg=#011627],#[bg=#011627#,fg=#122d42]#[bg=#122d42#,fg=#80A4C2] #W #[fg=#122d42#,bg=#011627]}"
set -g window-status-current-format "#[bg=#FFFFFF]#{?window_zoomed_flag,#[fg=#795DA3],#[fg=#CA1243]}#[fg=black]#{?window_zoomed_flag,#[bg=#795DA3],#[bg=#CA1243]} #{?pane_synchronized,#W  ,#W} #[bg=#FFFFFF]#{?window_zoomed_flag,#[fg=#795DA3],#[fg=#CA1243]}"
set -g window-status-bell-style "bg=red"
