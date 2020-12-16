{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      ../../desktop.nix
    ];

  networking = {
    hostName = "jc-nexvision";
    interfaces.enp2s0.useDHCP = true;
  };

  # Boot
  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];

    # MBR
    loader.grub.device = "/dev/sda";
  };

  # Partitions
  #
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
  };

  swapDevices =
    [ { device = "/dev/disk/by-label/swap"; } ];

  services.xserver = {
    videoDrivers = [ "nvidia" ];
  };

  hardware.opengl = {
    enable = true;

    extraPackages = with pkgs; [
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
    driSupport = true;
  };
}
