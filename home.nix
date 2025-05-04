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
    lsd
    htop
    lazygit
    nil
    nixd
    nixfmt-rfc-style
    ripgrep
    zoxide
    wally-cli
    markdownlint-cli2
    loupe

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
    hunspell
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

  xdg.desktopEntries.evince = {
    name = "Evince PDF viewer";
    exec = "${pkgs.evince}/bin/evince";
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "evince.desktop";
      "image/jpeg" = "org.gnome.Loupe.desktop";
      "image/png" = "org.gnome.Loupe.desktop";
      "image/gif" = "org.gnome.Loupe.desktop;";
      "image/webp" = "org.gnome.Loupe.desktop;";
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
    associations.removed = {
      "application/pdf" = "google-chrome.desktop";
      "application/rdf+xml" = "google-chrome.desktop";
      "application/rss+xml" = "google-chrome.desktop";
      "application/xhtml+xml" = "google-chrome.desktop";
      "application/xhtml_xml" = "google-chrome.desktop";
      "application/xml" = "google-chrome.desktop";
      "image/gif" = "google-chrome.desktop;";
      "image/jpeg" = "google-chrome.desktop;";
      "image/png" = "google-chrome.desktop;";
      "image/webp" = "google-chrome.desktop;";
      "text/html" = "google-chrome.desktop";
      "text/xml" = "google-chrome.desktop";
      "x-scheme-handler/http" = "google-chrome.desktop";
      "x-scheme-handler/https" = "google-chrome.desktop";
    };
  };

  # Do not change this
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
