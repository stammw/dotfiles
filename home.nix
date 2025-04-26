{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "jc";
  home.homeDirectory = "/home/jc";

  imports = [
    ./modules/alacritty
    ./modules/shell.nix
    ./modules/sway
  ];

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # CLI
    bat
    fd
    htop
    lazygit
    nil
    nixd
    nixfmt-rfc-style
    ripgrep
    zoxide
    wally-cli

    rustup

    #GUI
    google-chrome
    firefox
    pavucontrol
    nautilus
    signal-desktop
    ledger-live-desktop

    font-awesome
    powerline-fonts
    powerline-symbols
    nerd-fonts.symbols-only
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono

    grim
    kanshi
    mako
    slurp
    swaybg
    swaylock
    wl-clipboard
    wev

    python3
    tree-sitter
  ];

  # TODO: this should be moved to `graphical.nix` but is not working there
  gtk = {
    enable = true;
  };
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "Adwaita-dark";
      };
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 35;
  };

  programs.ranger = {
    enable = true;
  };
  programs.git = {
    enable = true;
    userEmail = "jc.begue+git@pm.me";
    userName = "Jean-Christophe BEGUE";
  };

  fonts.fontconfig.enable = true;

  # Do not change this
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
