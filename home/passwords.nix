{ pkgs, config, ... }:

{
  programs.firefox = {
    enable = true;
  };

  programs.brave.enable = true;

  programs.browserpass.enable = true;
  programs.browserpass.browsers = [ "firefox" "brave" ];

  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions ( exts: [ exts.pass-otp ]);
    settings = {
      PASSWORD_STORE_DIR = "${config.xdg.dataHome}/password-store";
      # Needed for PASS android to lookup identities
      PASSWORD_STORE_GPG_OPTS = "--no-throw-keyids";
      # NOTE: Not totally sure this is needed
      PASSWORD_STORE_ENABLE_EXTENSIONS = "true";
    };
  };
}
