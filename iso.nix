{ pkgs, ... }:
let
  dotfiles = pkgs.stdenv.mkDerivation {
    pname = "nix files";
    version = "1";

    src = [
      ./modules
      ./configuration.nix
      ./flake.lock
      ./graphical.nix
      ./home.nix
      ./hardware-configuration.nix
    ];

    unpackPhase = ''
      for srcFile in $src; do
        cp -r $srcFile $(stripHash $srcFile)
      done
    '';
    installPhase = ''
      mkdir -p $out/var/dotfiles
      cp -aR * $out/var/dotfiles
    '';
  };
in
{

  environment.systemPackages = with pkgs; [
    dotfiles
  ];
}
