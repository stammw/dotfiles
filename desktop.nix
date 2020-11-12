{ config, lib, pkgs, ... }:

{
  # Enable the X11 windowing system with i3.
  services.xserver = {
    enable = true;
    layout = "fr";

    libinput.enable = true;
    videoDrivers = [ "modesetting" "nvidia" ];

    desktopManager = {
      xterm.enable = false;
    };

    displayManager = {
      defaultSession = "none+i3";

      autoLogin = {
        enable = true;
        user = "jc";
      };
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        i3lock-fancy
        i3blocks
        rofi
        polybar
        signal-desktop
        feh
      ];
    };
  };

  # Enable sound.
  sound.enable = true;
  hardware = {
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
      extraModules = [ pkgs.pulseaudio-modules-bt ];
      extraConfig = "
        load-module module-switch-on-connect
      ";
    };
  };
}
