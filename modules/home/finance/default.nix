{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.delta.finance;
in
{
  options.delta.finance = {
    enable = lib.mkEnableOption "Finance";
  };

  config = lib.mkIf cfg.enable {
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
        ExecStart = "${pkgs.fava}/bin/fava /home/orlando/c/ledger/main.beancount";
      };
    };
  };
}
