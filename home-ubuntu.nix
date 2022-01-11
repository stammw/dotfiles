{ config, pkgs, lib, ... }:

let
zsh = pkgs.zsh.overrideAttrs ( oldAttrs: rec { meta.priority = 4; });
in {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "jcbegue";
  home.homeDirectory = "/home/jcbegue";


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;

  imports = [
    ./home-common.nix
  ];

  fonts.fontconfig.enable = true;

  programs.zsh = {
    profileExtra = ''
      export NIX_PATH=$HOME/.nix-defexpr/channels''${NIX_PATH:+:}$NIX_PATH
      source "$HOME/.nix-profile/etc/profile.d/nix.sh"
      source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    '';
  };

  programs.bash = {
    enable = true;
    profileExtra = ''
      export NIX_PATH=$HOME/.nix-defexpr/channels''${NIX_PATH:+:}$NIX_PATH
      source "$HOME/.nix-profile/etc/profile.d/nix.sh"
      source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    '';
  };
  home.packages = with pkgs; [
      i3lock-fancy
      i3blocks
      polybarFull
      feh
      (nerdfonts.override {
        fonts = [ "FiraCode" "DroidSansMono" ];
      })
      siji
  ];

  home.file.".xsessionrc".text = ''
    export NIX_PATH=$HOME/.nix-defexpr/channels''${NIX_PATH:+:}$NIX_PATH
    source "$HOME/.nix-profile/etc/profile.d/nix.sh"
    source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    export XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_DIRS"
  '';

  home.stateVersion = "21.11";
}
