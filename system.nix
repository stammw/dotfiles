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
    LC_ALL = "en_US.UTF-8";
  };

  boot = {
    # Kernel Version
    kernelPackages = pkgs.linuxPackages_5_8;

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
