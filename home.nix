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
    ./modules/shell.nix
    ./modules/sway
  ];

  programs.anyrun = {
    enable = true;
    package = pkgs.anyrun;
    config = {
      x = {
        fraction = 0.5;
      };
      y = {
        fraction = 0.3;
      };
      width = {
        fraction = 0.3;
      };
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "top";
      hidePluginInfo = false;
      closeOnClick = false;
      showResultsImmediately = true;
      maxEntries = null;

      plugins = [
        # An array of all the plugins you want, which either can be paths to the .so files, or their packages
        "${pkgs.anyrun}/lib/libapplications.so"
        # "${pkgs.anyrun}/lib/libkidex.so"
        # shell
      ];
    };

    extraCss = ''
            #window {
              background-color: rgba(0, 0, 0, 0);
              font-size: 20px;
              color: #ffffff;
            }

            box#main {
              background-color: rgba(38, 38, 38, 0.8);
            }

            entry#entry {
              min-height: 40px;
              background: transparent;
              box-shadow: none;
              border: none;
            }

            list#main {
              color: #FFFFFF;
              background-color: rgba(0, 0, 0, 0);
            }

            #plugin {
              background: transparent;
              padding-bottom: 5px;
            }

            #match {
              padding: 2.5px;
            }

            #match:selected {
              background: transparent;
              border-right: 4px solid #7e9cd8;
              border-left: 4px solid #7e9cd8;
              border-radius: 4px;
            }

            #match:selected label#info {
              animation: fade 0.1s linear
            }

            @keyframes fade {
              0% {
                color: transparent;
              }

              100% {
                color: #b0b0b0;
              }
            }
      /*
            #match label#info {
              color: transparent;
            }

            #match:hover {
              background: transparent;
            }

            label#match-desc {
              font-size: 20px;
            }

            label#plugin {
              font-size: 14px;
            }
            */
    '';
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # CLI
    alsa-utils
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
    zbar

    # Dev
    rustup
    direnv
    meson
    cmake
    gcc
    pkg-config

    # These are nautilus build deps
    glib.dev
    gtk3.dev
    gtk4.dev
    gexiv2
    gexiv2.dev

    # GUI
    cheese
    deluge-gtk
    firefox
    freecad
    google-chrome
    ledger-live-desktop
    loupe
    nautilus
    obsidian
    pavucontrol
    signal-desktop
    vlc

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
