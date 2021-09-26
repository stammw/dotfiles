{ config, lib, pkgs, ... }:

{
  # Enable the X11 windowing system with i3.
  services.xserver = {
    enable = true;
    layout = "fr";

    libinput.enable = true;
    ## Set this from machine file
    ## videoDrivers = [ "modesetting" "nvidia" ];

    displayManager = {
      defaultSession = "none+i3";
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        i3lock-fancy
        i3blocks
        rofi
        polybarFull
        feh
      ];
      extraSessionCommands = ''
        eval $(${pkgs.gnome3.gnome-keyring}/bin/gnome-keyring-daemon --daemonize --components=ssh,secrets)
        export SSH_AUTH_SOCK
      '';
    };
  };

  # Gnome stuff
  programs.dconf.enable = true;
  services.gnome.gnome-keyring.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware = {
    pulseaudio = {
      support32Bit = true;
      enable = true;
      package = pkgs.pulseaudioFull;
      extraModules = [ pkgs.pulseaudio-modules-bt ];
      extraConfig = "
        load-module module-switch-on-connect
      ";
    };
  };
}
