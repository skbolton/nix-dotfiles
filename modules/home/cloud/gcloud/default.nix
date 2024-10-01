{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.delta.cloud.gcloud;
in
{
  options.delta.cloud.gcloud = with types; {
    enable = mkEnableOption "gcloud";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      USE_GKE_GCLOUD_AUTH_PLUGIN = "True";
    };

    home.packages = with pkgs; [
      (google-cloud-sdk.withExtraComponents [
        google-cloud-sdk.components.kubectl
        google-cloud-sdk.components.gke-gcloud-auth-plugin
        google-cloud-sdk.components.pubsub-emulator
      ])
    ];
  };
}
