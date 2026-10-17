{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.delta.desktop.wayland.mango;
in
{
  options.delta.desktop.wayland.mango = {
    enable = lib.mkEnableOption "mango";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      msnap
    ];

    wayland.windowManager.mango = {
      enable = true;

      settings = {
        repeat_rate = 50;
        xkb_rules_layout = "us";
        xkb_rules_variant = "colemak";
        xkb_rules_options = "lv3:ralt_alt";

        window_rule = [
          "tags:1,title:kitty"
          "tags:2,title:.*Firefox.*"
          "is_floating:1,width:0.5,height:0.8,title:kitty-nnn"
          "is_floating:1,app_id:com.danklinux.dms"

          # scratchpads
          "is_named_scratchpad:1,width:0.33,height:0.95,offset_x:-100,title:kitty-scratch"
          "is_named_scratchpad:1,width:0.25,height:0.95,offset_x:100,title:Plexamp"
        ];

        device_rule = [
          "name:Ploopy Corporation Ploopy Adept Trackball Mouse,natural_scrolling:1"
        ];

        tag_rule = [
          "id:1,layout_name:right_tile,master_factor:0.66"
        ];

        bind = [
          # Tags
          "SUPER,1,view,1"
          "SUPER,2,view,2"
          "SUPER,3,view,3"
          "SUPER,4,view,4"
          "SUPER,5,view,5"
          "SUPER,6,view,6"
          "SUPER,7,view,7"
          "SUPER,8,view,8"
          "SUPER,9,view,9"
          "SUPER+CTRL,1,toggleview,1"
          "SUPER+CTRL,2,toggleview,2"
          "SUPER+CTRL,3,toggleview,3"
          "SUPER+CTRL,4,toggleview,4"
          "SUPER+CTRL,5,toggleview,5"
          "SUPER+CTRL,6,toggleview,6"
          "SUPER+CTRL,7,toggleview,7"
          "SUPER+CTRL,8,toggleview,8"
          "SUPER+CTRL,9,toggleview,9"
          "SUPER+ALT,1,tag,1"
          "SUPER+ALT,2,tag,2"
          "SUPER+ALT,3,tag,3"
          "SUPER+ALT,4,tag,4"
          "SUPER+ALT,5,tag,5"
          "SUPER+ALT,6,tag,6"
          "SUPER+ALT,7,tag,7"
          "SUPER+ALT,8,tag,8"
          "SUPER+ALT,9,tag,9"

          # View
          "SUPER,h,focusdir,left"
          "SUPER,j,focusdir,down"
          "SUPER,k,focusdir,up"
          "SUPER,l,focusdir,right"
          "SUPER+CTRL,h,exchange_client,left"
          "SUPER+CTRL,j,exchange_client,down"
          "SUPER+CTRL,k,exchange_client,up"
          "SUPER+CTRL,l,exchange_client,right"
          "SUPER,t,setlayout,right_tile"
          "SUPER,c,setlayout,center_tile"
          "SUPER,z,zoom"
          "SUPER,f,togglefullscreen"
          # SPAWNS
          "SUPER,Return,spawn,kitty"
          "ALT,d,spawn,dms ipc call spotlight toggle"
          "SUPER,n,spawn_shell,kitty -T kitty-nnn zsh -i -c 'nnn -P p -S -s default -Q'"
          # Scratchpads
          "SUPER+SHIFT,t,toggle_named_scratchpad,none,kitty-scratch,kitty -T kitty-scratch"
          "SUPER+SHIFT,m,toggle_named_scratchpad,plexamp,Plexamp,plexamp"

          # Util
          "SUPER+SHIFT,q,quit"
          "SUPER,w,killclient"
          "SUPER+SHIFT,r,reload_config"
          "SUPER+ALT,v,spawn,dms ipc call clipboard toggle"
          "NONE,Print,spawn,msnap gui"
        ];
      };
    };
  };
}
