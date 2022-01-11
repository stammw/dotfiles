{ config, lib, pkgs, ... }:
let
  home-manager = builtins.fetchGit {
    url = "https://github.com/nix-community/home-manager.git";
    ref = "release-21.05";
  };
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };

  jdt-language-server = pkgs.callPackage ./packages/jdt-language-server.nix {};

  gcc = pkgs.gcc.overrideAttrs ( oldAttrs: rec { meta.priority = 5; });
  clang_11 = pkgs.clang.overrideAttrs ( oldAttrs: rec { meta.priority = 6; });

in {
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

  home-manager.users.jc = lib.mkMerge [
      (import ./home-common.nix { config=config; lib=lib; pkgs=pkgs; })
      ({
        home.packages = with pkgs; [
          # GUI tools
          steam
          libreoffice

          # CLI tools
          binutils
          coreutils
          gcc

          # Networking
          openfortivpn

          # Learn
          exercism

          # Python
          python37Full
          python37Packages.ipython

          # Virtualization
          vagrant
        ];
    })
  ];

  programs.zsh = {
    profileExtra = ''
      source /etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh
    '';
  };
}
