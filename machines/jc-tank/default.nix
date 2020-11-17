{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      ../../desktop.nix
    ];

  networking = {
    hostName = "jc-tank";
    interfaces.enp0s0f0.useDHCP = true;
  };

  # Boot
  #
  # TODO
  # boot = {
  #   initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  #   initrd.kernelModules = [ "dm-snapshot" ];
  #   kernelModules = [ "kvm-intel" ];
  #   extraModulePackages = [ ];
  # };

  # Partitions
  #
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      options = [ "noatime" "nodiratime" "discard" ];
    };
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };
  };

  swapDevices =
    [ { device = "/dev/disk/by-label/swap"; } ];

  services.xserver = {
    videoDrivers = [ "intel" ];
  };
}
