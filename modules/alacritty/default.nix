{ pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.92;
      };
      general.import = [
        ./catppuccin-mocha.toml
      ];
      font = {
        normal.family = "Fira Code Nerd Font";
        size = 15;
      };
    };
  };
}
