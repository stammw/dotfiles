{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nixos-generators,
      ...
    }:
    {
      nixosConfigurations.jc-laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
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
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.jc = import ./home.nix;
            home-manager.backupFileExtension = "hm-backup";
          }
        ];
      };

      packages.x86_64-linux.iso = inputs.nixos-generators.nixosGenerate {
        system = "x86_64-linux";
        format = "install-iso";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix"
          {
            system.stateVersion = "24.05";
          }
          ./iso.nix
        ];
      };
    };
}
