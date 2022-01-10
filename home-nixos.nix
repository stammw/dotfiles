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
      (import ./home.nix { config=config; lib=lib; pkgs=pkgs; })
      ({
        home.packages = with pkgs; [
          python37Full
          python37Packages.ipython
          black
          python-language-server
          binutils
          coreutils
          gcc
          vagrant

          gnome3.nautilus
          gnome3.gnome-screenshot
          gnome3.eog
          exercism
        ];
    })
  ];
}
