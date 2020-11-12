{ config, lib, ... }:
let
  home-manager = builtins.fetchGit {
    url = "https://github.com/nix-community/home-manager.git";
    ref = "release-20.09";
  };

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

      # CLI tools
      fzf
      exa
      fd
      ripgrep
      unzip
      htop

      # Rust <3
      rustup
      rust-analyzer

      # C
      clang
      binutils
      coreutils
      gcc

      # Python
      python37Full
      python37Packages.ipython
      python-language-server
    ];

    xdg.configFile."alacritty/alacritty.yml".source = configs/alacritty.yml;

    # Shell
    programs.zsh = {
      enable = true;
      enableCompletion = true;
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
