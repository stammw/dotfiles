{ pkgs, ... }:
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "monospace:size=18";
        prompt = "' '";
        icon-theme = "Adwaita";
        width = 40;
        horizontal-pad = 24;
        vertical-pad = 16;
        inner-pad = 8;
        layer = "overlay";
        lines = 8;
      };
      colors = {
        background = "1e1e2ee6";
        text = "cdd6f4ff";
        prompt = "cdd6f4ff";
        input = "cdd6f4ff";
        match = "cba6f7ff";
        selection = "45475a80";
        selection-text = "cdd6f4ff";
        selection-match = "cba6f7ff";
        border = "45475a99";
      };
      border = {
        width = 1;
        radius = 16;
      };
    };
  };
}
