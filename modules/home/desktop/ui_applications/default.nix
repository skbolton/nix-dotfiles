{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.delta.desktop.ui_applications;
in
{
  options.delta.desktop.ui_applications = with types; {
    enable = mkEnableOption "Desktop UI applications";
  };

  config = mkIf cfg.enable {
    # TODO: These need cleaning up!
    home.packages = with pkgs; [
      slack
      zoom-us
      nautilus
      lxappearance
      arandr
      gnucash
      morgen
      mpv
      tidal-hifi
      font-manager
      foliate
      galculator
      wtype
      wofi-emoji
      wdisplays
      mission-center
    ];

    programs.wofi.enable = true;
    services.cliphist.enable = true;
  };
}
