{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.delta.ripping;
in
{
  options.delta.ripping = {
    enable = lib.mkEnableOption "ripping";
  };

  config = lib.mkIf cfg.enable {
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
