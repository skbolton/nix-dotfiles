{ inputs, pkgs, ... }:

{
  home.sessionVariables = {
    ERL_AFLAGS = "-kernel shell_history enabled";
  };

  home.packages = with pkgs; [
    elixir_1_15
    erlang_26
  ];
}

