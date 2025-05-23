{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.delta.finance;
in
{
  options.delta.finance = with types; {
    enable = mkEnableOption "Finance";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      fava
      beancount
    ];

    systemd.user.services.fava = {
      Unit = {
        Description = "Start Fava Web GUI";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        ExecStart = "${pkgs.fava}/bin/fava /home/orlando/Public/ledger/main.beancount";
      };
    };
  };
}

