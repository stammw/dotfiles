
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in
{
  imports =
    [ # Include the results of the hardware scan.
      <nixos-hardware/dell/xps/15-9500>
      ./hardware-configuration.nix
    ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_5_8;
  boot.blacklistedKernelModules = ["nouveau"];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices.vg.device = "/dev/disk/by-uuid/912bc249-1e34-4b8f-a2ae-9de8b7de3630";

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.enableCryptodisk = true;

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

  # Supposedly better for the SSD.
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  networking.hostName = "jc-laptop"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.wlp0s20f3.useDHCP = true;

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

  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr";
  };

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    alacritty
    antigen
    binutils
    bluez
    clang
    coreutils
    discord
    emacs
    evince
    exa
    fd
    firefox
    fzf
    gcc
    git
    htop
    libreoffice
    light
    nerdfonts
    nvidia-offload
    powertop
    python37Full
    python37Packages.ipython
    python-language-server
    ripgrep
    rust-analyzer
    rustup
    slack
    sshfs
    vim
    wget
    zsh
    unzip
    virtualbox
    (steam.override { withPrimus = true; extraPkgs = pkgs: [ bumblebee glxinfo ]; }).run
  ];
  environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw
  programs.steam.enable = true;

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

