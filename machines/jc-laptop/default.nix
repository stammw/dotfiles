{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      <nixos-hardware/dell/xps/15-9500>
      (modulesPath + "/installer/scan/not-detected.nix")
      ../../desktop.nix
    ];

  networking = {
    hostName = "jc-laptop";

    # Enable wireless (SSID-related stuff is in secrets.nix)
    wireless.enable = true;
    interfaces.wlp0s20f3.useDHCP = true;
  };

  # Boot
  #
  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
    initrd.kernelModules = [ "dm-snapshot" ];
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  }

  # Partitions
  #
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      options = [ "noatime" "nodiratime" "discard" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/24A0-126E";
      fsType = "vfat";
    };
  };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/88ba4245-3149-484c-a95e-b756455357ab"; } ];

  # Encrypted "nixos" volume
  boot.initrd.luks.devices.vg.device = "/dev/disk/by-uuid/912bc249-1e34-4b8f-a2ae-9de8b7de3630";

  # Bluetooth
  hardware = {
    bluetooth = {
      enable = true;
      config = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };

    nvidia.prime = {
      offload.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # Power saving
  #
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  boot.extraModprobeConfig = pkgs.lib.mkMerge [
    # idle audio card after one second
    "options snd_hda_intel power_save=1"
    # enable wifi power saving (keep uapsd off to maintain low latencies)
    "options iwlwifi power_save=1 uapsd_disable=1"
  ];

  services.tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        SOUND_POWER_SAVE_ON_AC = 0;
        SOUND_POWER_SAVE_ON_BAT = 1;
        RUNTIME_PM_ON_AC = "on";
        RUNTIME_PM_ON_BAT = "auto";
      };
    };

  services.udev.path = [
    pkgs.coreutils # for chgrp
  ];
  services.udev.extraRules = pkgs.lib.mkMerge [
    # autosuspend USB devices
    ''ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="auto"''
    # autosuspend PCI devices
    ''ACTION=="add", SUBSYSTEM=="pci", TEST=="power/control", ATTR{power/control}="auto"''
    ''
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video %S%p/brightness", RUN+="${pkgs.coreutils}/bin/chmod g+w %S%p/brightness"
    ''
  ];
}
