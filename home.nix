{ config, lib, pkgs, ... }:
let
  home-manager = builtins.fetchGit {
    url = "https://github.com/nix-community/home-manager.git";
    ref = "release-21.05";
  };

  jdt-language-server = pkgs.callPackage ./packages/jdt-language-server.nix {};

  gcc = pkgs.gcc.overrideAttrs ( oldAttrs: rec { meta.priority = 5; });
  clang_11 = pkgs.clang.overrideAttrs ( oldAttrs: rec { meta.priority = 6; });

in {
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

  home-manager.users.jc = { pkgs, ... }: {
    home.packages = with pkgs; [
      # GUI tools
      alacritty
      emacs
      evince
      discord
      signal-desktop
      #chromium
      gimp
      steam
      # freecad
      # libreoffice
      qalculate-gtk
      skype
      gnome3.nautilus
      arc-theme

      # CLI tools
      exa
      bat
      fd
      fzf
      htop
      ncdu
      pbzip2
      ranger
      ripgrep
      unzip
      gnupg
      xclip
      libqalculate
      unzip

      # HW
      lm_sensors
      powertop

      # Networking
      openfortivpn
      tshark

      # Rust <3
      rustup
      rust-analyzer
      exercism

      # deps
      pkg-config
      openssl.dev

      # C
      clang_11
      clang-tools
      binutils
      coreutils
      gcc
      ccls
      bear
      gnumake

      # Python
      python37Full
      python37Packages.ipython
      black
      python-language-server

      # Java
      # openjdk11
      # android-studio
      # android-udev-rules
      # androidenv.androidPkgs_9_0.platform-tools
      # jdt-language-server

      # Virtualisation
      docker-compose
    ];

    # XDG
    # Alacritty
    xdg.configFile."alacritty/alacritty.yml".source = configs/alacritty.yml;
    # I3
    xdg.configFile."i3/config".source = configs/i3/config;
    xdg.configFile."i3/wallpaper.jpg".source = configs/i3/wallpaper.jpg;
    xdg.configFile."i3/xrandr.sh".source = configs/i3/xrandr.sh;
    xdg.configFile."polybar/config".source = configs/polybar/config;
    xdg.configFile."polybar/launch.sh".source = configs/polybar/launch.sh;

    # Shell
    programs.starship.enable = true;
    programs.command-not-found.enable = true;
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      initExtraFirst = ''
        function zvm_config() {
            ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
            ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_UNDERLINE
            ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
        }

        function zvm_after_init() {
          source "$(fzf-share)/key-bindings.zsh"
          source "$(fzf-share)/completion.zsh"

          bindkey "^[." insert-last-word
        }

        # The following should not be necessary as `programs.direnv.enableZshIntegration`
        # should do it (but it doesn't)...
        eval "$(${pkgs.direnv}/bin/direnv hook zsh)"
      '';
      zplug = {
        enable = true;
        plugins = [
          { name = "zsh-users/zsh-syntax-highlighting"; }
          { name = "jeffreytse/zsh-vi-mode"; }
        ];
      };
    };

    programs.bash = {
      enable = true;
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = false;
    };

    # Editor
    home.file.".doom.d/init.el".source = configs/emacs/init.el;
    home.file.".doom.d/packages.el".source = configs/emacs/packages.el;
    home.file.".doom.d/config.el".source = configs/emacs/config.el;

    programs.git = {
      package = pkgs.gitAndTools.gitFull;
      enable = true;
      userName = "Jean-Christpohe BEGUE";
      userEmail = "jc.begue@pm.me";
    };

    gtk = {
      enable = true;
      iconTheme = {
        name = "Arc";
        package = pkgs.arc-icon-theme;
      };
      theme = {
        name = "Arc-Dark";
        package = pkgs.arc-theme;
      };
    };

    programs.firefox = {
      enable = true;
      profiles."default".settings = {
        "browser.display.background_color" = "#3C414E";
        "devtools.theme" = "dark";
        # Enable userContent.css and userChrome.css for our theme modules
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        # Don't use the built-in password manager; a nixos user is more likely
        # using an external one (you are using one, right?).
        "signon.rememberSignons" = false;
        # Do not check if Firefox is the default browser
        "browser.shell.checkDefaultBrowser" = false;
        # Disable the "new tab page" feature and show a blank tab instead
        # https://wiki.mozilla.org/Privacy/Reviews/New_Tab
        # https://support.mozilla.org/en-US/kb/new-tab-page-show-hide-and-customize-top-sites#w_how-do-i-turn-the-new-tab-page-off
        "browser.newtabpage.enabled" = false;
        "browser.newtab.url" = "about:blank";
        # Don't ask for session resume on startup
        "browser.sessionstore.resume_session_once" = false;
        # Disable Activity Stream
        # https://wiki.mozilla.org/Firefox/Activity_Stream
        "browser.newtabpage.activity-stream.enabled" = false;
        # Disable new tab tile ads & preload
        # http://www.thewindowsclub.com/disable-remove-ad-tiles-from-firefox
        # http://forums.mozillazine.org/viewtopic.php?p=13876331#p13876331
        # https://wiki.mozilla.org/Tiles/Technical_Documentation#Ping
        # https://gecko.readthedocs.org/en/latest/browser/browser/DirectoryLinksProvider.html#browser-newtabpage-directory-source
        # https://gecko.readthedocs.org/en/latest/browser/browser/DirectoryLinksProvider.html#browser-newtabpage-directory-ping
        "browser.newtabpage.enhanced" = false;
        "browser.newtab.preload" = false;
        "browser.newtabpage.directory.ping" = "";
        "browser.newtabpage.directory.source" = "data:text/plain,{}";
        # Disable some not so useful functionality.
        "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        "extensions.htmlaboutaddons.discover.enabled" = false;
        "extensions.pocket.enabled" = false;
        "app.normandy.enabled" = false;
        "app.normandy.api_url" = "";
        "extensions.shield-recipe-client.enabled" = false;
        "app.shield.optoutstudies.enabled" = false;
        # Disable battery API
        # https://developer.mozilla.org/en-US/docs/Web/API/BatteryManager
        # https://bugzilla.mozilla.org/show_bug.cgi?id=1313580
        "dom.battery.enabled" = false;
        # Disable "beacon" asynchronous HTTP transfers (used for analytics)
        # https://developer.mozilla.org/en-US/docs/Web/API/navigator.sendBeacon
        "beacon.enabled" = false;
        # Disable pinging URIs specified in HTML <a> ping= attributes
        # http://kb.mozillazine.org/Browser.send_pings
        "browser.send_pings" = false;
        # Disable gamepad API to prevent USB device enumeration
        # https://www.w3.org/TR/gamepad/
        # https://trac.torproject.org/projects/tor/ticket/13023
        "dom.gamepad.enabled" = false;
        # Don't try to guess domain names when entering an invalid domain name in URL bar
        # http://www-archive.mozilla.org/docs/end-user/domain-guessing.html
        "browser.fixup.alternate.enabled" = false;
        # Disable telemetry
        # https://wiki.mozilla.org/Platform/Features/Telemetry
        # https://wiki.mozilla.org/Privacy/Reviews/Telemetry
        # https://wiki.mozilla.org/Telemetry
        # https://www.mozilla.org/en-US/legal/privacy/firefox.html#telemetry
        # https://support.mozilla.org/t5/Firefox-crashes/Mozilla-Crash-Reporter/ta-p/1715
        # https://wiki.mozilla.org/Security/Reviews/Firefox6/ReviewNotes/telemetry
        # https://gecko.readthedocs.io/en/latest/browser/experiments/experiments/manifest.html
        # https://wiki.mozilla.org/Telemetry/Experiments
        # https://support.mozilla.org/en-US/questions/1197144
        # https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/internals/preferences.html#id1
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "experiments.supported" = false;
        "experiments.enabled" = false;
        "experiments.manifest.uri" = "";
        # Disable health reports (basically more telemetry)
        # https://support.mozilla.org/en-US/kb/firefox-health-report-understand-your-browser-perf
        # https://gecko.readthedocs.org/en/latest/toolkit/components/telemetry/telemetry/preferences.html
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.healthreport.service.enabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "firefox.enableAdobeFlash" = false;
      };
    };
  };
}
