{
  config,
  pkgs,
  ...
}:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "jc";
  home.homeDirectory = "/home/jc";

  imports = [
    ./modules/alacritty
    ./modules/fuzzel.nix
    ./modules/shell.nix
    ./modules/sway
    ./modules/hyprland
  ];

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # CLI
    alsa-utils
    bat
    fd
    ffmpeg
    lsd
    htop
    lazygit
    nil
    nixd
    nixfmt
    ripgrep
    keymapp
    markdownlint-cli2
    unzip
    zbar

    # Dev
    rustup
    cmake
    meson
    gcc
    pkg-config

    # These are nautilus build deps
    glib.dev
    gtk3.dev
    gtk4.dev
    gexiv2_0_16
    gexiv2_0_16.dev

    # GUI
    cheese
    deluge-gtk
    fragments
    firefox
    google-chrome
    ledger-live-desktop
    loupe
    nautilus
    obs-studio
    obsidian
    (signal-desktop.overrideAttrs (old: {
      preFixup = (old.preFixup or "") + ''
        wrapProgram $out/bin/signal-desktop \
          --add-flags '--password-store="gnome-libsecret"'
      '';
    }))
    vlc
    pwvucontrol
    claude-code
    tidal-hifi

    # Fonts
    font-awesome
    powerline-fonts
    powerline-symbols
    nerd-fonts.symbols-only
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono

    # Desktop tools
    grim
    kanshi
    libnotify
    playerctl
    slurp
    swaybg
    swaylock
    tradingview
    wl-clipboard
    wev
    solaar
    wine

    python3
    tree-sitter
    hunspell
  ];

  # TODO: this should be moved to `graphical.nix` but is not working there
  gtk = {
    enable = true;
    theme.name = "Adwaita";
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.theme = null;
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "Adwaita";
      };
    };
  };

  home.pointerCursor = {
    enable = true;
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
    signing.format = null;
    settings.user.email = "jc.begue+git@pm.me";
    settings.user.name = "Jean-Christophe BEGUE";
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

  services.udiskie = {
    enable = true;
    tray = "auto";
    notify = true;
  };

  # Do not change this
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
