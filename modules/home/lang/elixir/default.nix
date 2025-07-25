{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.delta.lang.elixir;
in
{
  options.delta.lang.elixir = with types; {
    enable = mkEnableOption "Elixir Language support";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      postgresql
      elixir_1_17
      erlang_27
      lexical
    ] ++ lib.optional stdenv.isLinux inotify-tools
    ++ lib.optional stdenv.isDarwin terminal-notifier;

    home.sessionVariables = {
      ERL_AFLAGS = "-kernel shell_history enabled";
    };

    home.file.".iex.exs".text = /* elixir */ ''
      IEx.configure(
              default_prompt:
                "#{IO.ANSI.magenta} #{IO.ANSI.reset}(%counter) |",
              continuation_prompt:
                "#{IO.ANSI.magenta} #{IO.ANSI.reset}(.) |"
            )
    '';

    programs.git.ignores = [ ".lexical" "scratchpad.ex" ".elixir-ls" ];

    xdg.configFile."nvim/lsp/lexical.lua".text = /* lua */ ''
      return {
        cmd = { 'lexical' },
        filetypes = { 'elixir', 'eelixir', 'heex', 'surface' },
        root_markers = { '.mix.exs', '.git'}
      }
    '';

    programs.neovim.extraLuaConfig = /* lua */ ''
      vim.lsp.enable('lexical')
    '';
  };
}

