{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    anyrun = {
      url = "github:anyrun-org/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      anyrun,
      ...
    }:
    let
      anyrun-overlay = final: prev: {
        anyrun = anyrun.packages.${prev.system}.anyrun-with-all-plugins;
        # plugins = {
        #   applications = anyrun.packages.${prev.system}.applications;
        # };
      };
      linux-firmware-overlay = final: prev: {
        linux-firmware = prev.linux-firmware.overrideAttrs (oldAttrs: {
          version = "20250708";
          src = final.pkgs.fetchzip {
            url = "https://cdn.kernel.org/pub/linux/kernel/firmware/linux-firmware-20250708.tar.xz";
            hash = "sha256-aQdEl9+7zbNqWSII9hjRuPePvSfWVql5u5TIrGsa+Ao=";
          };
        });
      };
    in
    {
      nixosConfigurations.jc-laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          { networking.hostName = "jc-laptop"; }
          ./configuration.nix
          ./graphical.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.jc = import ./home.nix;
            home-manager.backupFileExtension = "hm-backup";
          }
        ];
      };

      nixosConfigurations.jc-byebrain = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          { networking.hostName = "jc-byebrain"; }
          (
            { config, pkgs, ... }:
            {
              nixpkgs.overlays = [
                anyrun-overlay
                linux-firmware-overlay
              ];
            }
          )
          ./configuration.nix
          ./graphical.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.jc = import ./home.nix;
            home-manager.backupFileExtension = "hm-backup";
          }
        ];
      };
    };
}
