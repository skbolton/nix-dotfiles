{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.delta.lang.nix;
in
{
  options.delta.lang.nix = {
    enable = lib.mkEnableOption "Nix Language support";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      nixd
      nixfmt
    ];

    xdg.configFile."nvim/lsp/nixd.lua".text = /* lua */ ''
      local hostname = vim.uv.os_gethostname()
      local system = vim.uv.os_uname().sysname == 'Darwin' and 'darwin' or 'nixos'
      local flake = '(builtins.getFlake ("git+file://" + builtins.toString ./.))'

      return {
        cmd = { 'nixd' },
        filetypes = { 'nix' },
        root_markers = { 'flake.nix', 'shell.nix' },
        settings = {
          nixd = {
            nixpkgs = {
              expr = ('import %s.inputs.nixpkgs { }'):format(flake),
            },
            formatting = { command = { "nixfmt" } },
            options = {
              [system] = {
                expr = ('%s.%sConfigurations.%q.options'):format(flake, system, hostname),
              },
              home_manager = {
                expr = ('%s.%sConfigurations.%q.options.home-manager.users.type.getSubOptions []'):format(
                  flake,
                  system,
                  hostname
                ),
              },
            },
          },
        },
      }
    '';

    programs.neovim.initLua = /* lua */ ''
      vim.lsp.enable('nixd')
    '';
  };
}
