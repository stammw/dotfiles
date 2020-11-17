{ config, lib, pkgs, ... }:
let
  home-manager = builtins.fetchGit {
    url = "https://github.com/nix-community/home-manager.git";
    ref = "release-20.09";
  };

  jdt-language-server = pkgs.callPackage ./packages/jdt-language-server.nix {};
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

      # CLI tools
      exa
      fd
      fzf
      htop
      ncdu
      pbzip2
      ripgrep
      unzip
      gnupg

      # Rust <3
      rustup
      rust-analyzer

      # C
      #clang
      binutils
      coreutils
      gcc

      # Python
      python37Full
      python37Packages.ipython
      python-language-server

      # Java
      openjdk11
      android-studio
      android-udev-rules
      androidenv.androidPkgs_9_0.platform-tools
      jdt-language-server
    ];

    # XDG
    # Alacritty
    xdg.configFile."alacritty/alacritty.yml".source = configs/alacritty.yml;
    # I3
    xdg.configFile."i3/config".source = configs/i3/config;
    xdg.configFile."i3/xrandr.sh".source = configs/i3/xrandr.sh;
    xdg.configFile."polybar/config".source = configs/polybar/config;
    xdg.configFile."polybar/launch.sh".source = configs/polybar/launch.sh;

    # Shell
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      initExtra = ''
        . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      '';
      zplug = {
        enable = true;
        plugins = [
          { name = "zsh-users/zsh-syntax-highlighting"; }
          { name = "junegunn/fzf"; tags = [ "use:'shell/*.zsh'" ]; }
        ];
      };
      defaultKeymap = "vicmd";
    };
    programs.bash = {
      enable = true;
    };
    programs.starship.enable = true;
    programs.command-not-found.enable = true;

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

    programs.firefox.enable = true;
  };
}
