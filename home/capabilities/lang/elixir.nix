{ inputs, pkgs, ... }:

{
  home.packages = with pkgs; [
    elixir_1_15
    erlang_26
  ];
}

