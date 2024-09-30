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

    xdg.dataFile."password-store/.extensions/fzf.bash".source = pkgs.fetchFromGitHub
      {
        owner = "ficoos";
        repo = "pass-fzf";
        rev = "4a703e72c0887f2012de8e791e725181d1ce18d8";
        sha256 = "sha256-dKH7Tn0EFR5k/IH3b9GqpKmtbZ/Zc3e7gMDouUaJFRI=";
      } + "/fzf.bash";

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
