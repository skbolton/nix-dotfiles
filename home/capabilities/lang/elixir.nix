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

  home.packages = with pkgs; [
    elixir_1_15
    erlang_26
    inputs.lexical-lsp.packages.${system}.lexical
  ];
}

