{ pkgs, lib, ... }:

{
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

  home.packages = with pkgs; [
    postgresql
    elixir_1_15
    erlang_26
    lexical
  ] ++ lib.optional stdenv.isLinux inotify-tools
  ++ lib.optional stdenv.isDarwin terminal-notifier
  ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    CoreFoundation
    CoreServices
  ]);

  xdg.configFile."nvim/after/ftplugin/elixir.lua".text = /* lua */ ''
    local capabilities = require 'lsp_capabilities'()

    vim.lsp.start {
      name = 'lexical',
      cmd = { 'lexical' },
      capabilities = capabilities,
      root_dir = vim.fs.dirname(vim.fs.find({'mix.exs', '.git'}, { upward = true })[1]),
    }
  '';
}

