{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.delta.ripping;
in
{
  options.delta.ripping = with types; {
    enable = mkEnableOption "ripping";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      handbrake
      makemkv
      subtitleedit
      mkvtoolnix
      mpv
    ];

    boot.initrd.kernelModules = [ "sg" ];
  };
}
