{ pkgs, ...}:

{
  home.sessionVariables = {
    HARSHPATH = "$HOME/Life/00-09-System/03-Quantified/03.11-Habits/$(date +%Y)";
  };

  home.packages = with pkgs; [
    harsh
  ];
}
