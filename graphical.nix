{ pkgs, ... }:
{

  # users.users.greeter = { };
  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     default_session = {
  #       command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
  #       user = "greeter";
  #     };
  #   };
  # };

  security.polkit.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XKB_DEFAULT_LAYOUT = "us";
    XKB_DEFAULT_VARIANT = "altgr-intl";
    XKB_DEFAULT_OPTIONS = "compose:menu,level3:ralt_switch";
  };

  environment.systemPackages = with pkgs; [
    swaylock
    swaybg
    kanshi
    grim
    slurp
    wl-clipboard
    mako
    blueman
  ];

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = true;
    desktopManager.gnome.enable = true;
  };

  services.libinput.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
    ];
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.extraConfig = {
      "10-bluez" = {
        "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-hw-volume" = true;
          "bluez5.roles" = [
            "hfp_ag"
            "a2dp_sink"
            "a2dp_source"
          ];
        };
        "monitor.bluez.rules" = [
          {
            "matches" = [
              {
                ## This matches all bluetooth devices.
                "device.name" = "~bluez_card.*";
              }
            ];
            "actions" = {
              "update-props" = {
                "bluez5.auto-connect" = [
                  "a2dp_sink"
                  "a2dp_source"
                ];
                "bluez5.hw-volume" = [
                  "a2dp_sink"
                  "a2dp_source"
                ];
                "bluez5.a2dp.ldac.quality" = "auto";
                "bluez5.a2dp.aac.bitratemode" = 0;
                "bluez5.a2dp.opus.pro.application" = "audio";
                "bluez5.a2dp.opus.pro.bidi.application" = "audio";
              };
            };
          }
        ];
      };
      "11-bluetooth-policy" = {
        "wireplumber.settings" = {
          "bluetooth.autoswitch-to-headset-profile" = false;
        };
      };
    };
  };

  # Enable the gnome-keyring secrets vault.
  # Will be exposed through DBus to programs willing to store secrets.
  services.gnome.gnome-keyring.enable = true;
  programs.dconf.enable = true;

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "jc" ];
  };

  environment.etc = {
    "1password/custom_allowed_browsers" = {
      text = ''
        chrome
      '';
      mode = "0755";
    };
  };
}
