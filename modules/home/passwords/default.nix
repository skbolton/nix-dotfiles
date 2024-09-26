{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.delta.passwords;
in
{
  options.delta.passwords = with types; {
    enable = mkEnableOption "password management";

    browsers = mkOption {
      type = types.listOf (types.enum [ "brave" "chrome" "chromium" "firefox" "librewolf" "vivaldi" ]);
      default = [ "firefox" "brave" ];
      example = [ "firefox" ];
      description = "Which browsers to install browserpass for";
    };
  };

  config = mkIf cfg.enable {
    programs.browserpass = {
      enable = true;
      browsers = [ "firefox" "brave" ];
    };

    programs.password-store = {
      enable = true;
      package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
      settings = {
        PASSWORD_STORE_DIR = "${config.xdg.dataHome}/password-store";
        # Needed for PASS android to lookup identities
        PASSWORD_STORE_GPG_OPTS = "--no-throw-keyids";
        # NOTE: Not totally sure this is needed
        PASSWORD_STORE_ENABLE_EXTENSIONS = "true";
      };
    };
  };
}
