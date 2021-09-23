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
  imports = [
    ./system.nix
    ./machines/current.nix
    ./home.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };
  programs.steam.enable = true;
  virtualisation.docker.enable = true;

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    git
    light
    bluezFull
    nerdfonts
    sshfs
    vim
    wget
    zsh
    nvidia-offload
    glxinfo
    vulkan-tools
    ldacbt
  ];

  environment.pathsToLink = [ "/libexec"  "/share/zsh" ];

  hardware.nvidia.prime = {
    offload.enable = true;

    # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
    intelBusId = "PCI:0:2:0";

    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
    nvidiaBusId = "PCI:1:0:0";
  };

  fonts.fonts = with pkgs; [
    (nerdfonts.override {
      fonts = [ "FiraCode" "DroidSansMono" ];
    })
    siji
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jc = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "video" "adbusers" "docker" "libvirtd"];
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

