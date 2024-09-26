{ lib, config, ... }:

let
  inherit (lib) mkOption types;
in
{
  options.keyboard = mkOption {
    type = types.submodule {
      options = {
        variant = mkOption {
          type = types.str;
          example = "colemak";
          default = "";
        };
        options = mkOption {
          type = types.str;
          example = "lv3:ralt_alt";
          default = "";
        };
      };
    };
    default = { };
  };
}
