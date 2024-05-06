{ inputs, pkgs, ... }:

{
  home.sessionVariables = {
    ERL_AFLAGS = "-kernel shell_history enabled";
  };

  home.file.".iex.exs".text = ''
    IEx.configure(
            default_prompt:
              "#{IO.ANSI.magenta} #{IO.ANSI.reset}(%counter) |",
            continuation_prompt:
              "#{IO.ANSI.magenta} #{IO.ANSI.reset}(.) |"
          )
  '';

  programs.git.ignores = [ ".lexical" "scratchpad.ex" ".elixir-ls" ];

  home.packages = with pkgs; [
    inotify-tools
    postgresql
    elixir_1_15
    erlang_26
    # (inputs.lexical-lsp.lib.mkLexical { erlang = beam.packages.erlang_26; })
  ];
}

