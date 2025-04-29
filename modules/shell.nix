{ pkgs, ... }:
let
  shellAliases = {
    vim = "nvim";
  };
in
{
  programs.starship.enable = true;
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.fzf.enable = true;

  programs.fish = {
    enable = true;
    shellAliases = shellAliases;

    shellInit = ''
      set -U fish_greeting
      fish_vi_key_bindings

      set fish_cursor_default block
      set fish_cursor_insert line
      set fish_cursor_replace_one underscore
      set fish_cursor_replace underscore

      bind --mode insert \b         'backward-kill-word'     # C-backspace
      bind --mode insert \e\x7F     'backward-kill-bigword'  # M-backspace
      bind --mode insert \e\[P      'delete-char'            # Del
      bind --mode insert \e\[3\;5~  'kill-word'              # C-Del
      bind --mode insert \e\[3\;2~  'kill-bigword'           # S-Del

      bind --mode insert \cP         'up-or-search'           # C-P
      bind --mode insert \cN         'down-or-search'        # C-N
    '';
  };
}
