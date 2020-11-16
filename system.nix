{ pkgs, ... }:

{
  # Set your time zone.
  time.timeZone = "Europe/Paris";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr";
  };

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
    LC_COLLATE = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_MESSAGES = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_ADDRESS = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };

  boot = {
    # Kernel Version
    kernelPackages = pkgs.linuxPackages_latest;

    blacklistedKernelModules = ["nouveau"];

    # Use the systemd-boot EFI boot loader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    # Use the GRUB 2 boot loader.
    loader.grub.enable = true;
    loader.grub.version = 2;
    loader.grub.device = "nodev";
    loader.grub.efiSupport = true;
    loader.grub.enableCryptodisk = true;
  };
}
