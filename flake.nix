{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    claude-desktop = {
      url = "github:k3d3/claude-desktop-linux-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      claude-desktop,
      ...
    }:
    let
      claude-desktop-overlay = final: prev: {
        claude-desktop = claude-desktop.packages.${prev.system}.claude-desktop;
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
          (
            { config, pkgs, ... }:
            {
              nixpkgs.overlays = [
                claude-desktop-overlay
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

      nixosConfigurations.jc-byebrain = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          { networking.hostName = "jc-byebrain"; }
          (
            { config, pkgs, ... }:
            {
              nixpkgs.overlays = [
                claude-desktop-overlay
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

      nixosConfigurations.vm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          { networking.hostName = "nixos-vm"; }
          (
            { config, pkgs, ... }:
            {
              nixpkgs.overlays = [
                claude-desktop-overlay
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
          {
            users.users.jc.initialPassword = "test";
            virtualisation.vmVariant = {
              virtualisation = {
                memorySize = 4096;
                cores = 4;
                qemu.options = [
                  "-device virtio-vga-gl"
                  "-display gtk,gl=on"
                ];
              };
            };
          }
        ];
      };
    };
}
