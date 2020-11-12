{ config, pkgs, ... }:

{
  imports = [
    ./secrets.nix
    ./system.nix
    ./machines/current.nix
    ./home.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    bluez
    git
    light
    nerdfonts
    sshfs
    vim
    wget
    zsh
  ];
  environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw

  fonts.fonts = with pkgs; [
    (nerdfonts.override {
      fonts = [ "FiraCode" "DroidSansMono" ];
    })
    siji
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

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
        dmenu #application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock-fancy #default i3 screen locker
        i3blocks #if you are planning on using i3blocks over i3status
        rofi
        polybar
        signal-desktop
        feh
      ];
    };
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jc = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "video" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCcN+hBqktUOoWG8z+u/ZjpzTTJta15hTTe6Km7oj4q4KhkpT1lUqCgVDRRe8gv+Sz+m4f5hZlmWourrFiTlc5lAyBQTaReXTNzdzJ1unkg+vPfL/GSoK5NfEC4QIszcQaPHuYdLcw09I838Xxqp/jbw5B2m9vhtGVyE51hG70q2ze88J518c6lJifNh1kxdrNO/91GnvAY7t9TmoG0Ronb5Mv8rvTn7b4zPMWzsmdorZPtzScLUsve5lcZYydruqHJ4ekJOXhFB0FChtWR/FlHpW2hJmCyHAVKKqNKAxV4BRjQevqEN+Deu+8jPf+ajHgD69XN20zs+RUMeZHwzedVCy9Tg/2wQR/c6QCSjgX1w9OxoF+0bCtavq2hra1Jh85bm/Qus+SiBB1h3J0VEXCQ+gSjOq5SVnNJTvBBM6ThCSBL3ZiA+2Bdmsij5Oik3qzjtJat1U0JFoZoDre+81a6I1Klok02Va1xMy+FAMC4pDSjsoJDCnK5y/4AxAhNeWKTxwdhsMUgr3wm5e1i5Lzb+oJLJMiaRyPhuCm7x3FxMGJ62En3rRyjYN42NDDaAqbvdbhdtzp6LNC4PUP6N6i7q8PWxLIsW9hm+x/zxxuhPa1ewumvA48B1q4YWLhzqAiUMYM4vXti6k3LMTbiBLniwK+JCxXKWvat7hyMaZYKDw== begue.jc@gmail.com" ];
  };


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.03"; # Did you read the comment?
}

