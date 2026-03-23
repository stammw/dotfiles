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

  services.libinput.enable = true;

  environment.systemPackages = with pkgs; [
    swaylock
    swaybg
    kanshi
    grim
    slurp
    wl-clipboard
    mako
    blueman
    claude-desktop
    hyprlock
  ];

  programs.noisetorch.enable = true;

  services.displayManager = {
    gdm.enable = true;
    gdm.wayland = true;
  };


  services.gnome.gnome-keyring.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;
  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.hyprlock = {};

  programs.dconf.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config = {
      common.default = [ "gtk" ];
      hyprland = {
        default = [ "hyprland" "gtk" ];
        "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
      };
    };
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    extraConfig.pipewire."99-echo-cancel" = {
      "context.modules" = [
        {
          name = "libpipewire-module-echo-cancel";
          args = {
            "library.name" = "aec/libspa-aec-webrtc";
            "monitor.mode" = true;
            "capture.props" = {
              "node.name" = "echo-cancel-capture";
              "node.description" = "Echo-Cancel Capture";
            };
            "source.props" = {
              "node.name" = "echo-cancel-source";
              "node.description" = "Echo-Cancel Source";
            };
            "sink.props" = {
              "node.name" = "echo-cancel-sink";
              "node.description" = "Echo-Cancel Sink";
            };
            "playback.props" = {
              "node.name" = "echo-cancel-playback";
              "node.description" = "Echo-Cancel Playback";
            };
          };
        }
      ];
    };
    wireplumber.extraConfig = {
      "10-bluez" = {
        "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-hw-volume" = true;
          "bluez5.roles" = [
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
      "50-default-sink" = {
        "monitor.alsa.rules" = [
          {
            "matches" = [
              {
                "node.name" = "alsa_output.usb-CA_CA_DacMagic_200M_2.0-00.iec958-stereo";
              }
            ];
            "actions" = {
              "update-props" = {
                "priority.driver" = 2000;
                "priority.session" = 2000;
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

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "jc" ];
  };

  environment.etc = {
    "xdg/xdg-desktop-portal/portals/gtk.portal" = {
      text = ''
        [portal]
        DBusName=org.freedesktop.impl.portal.desktop.gtk
        Interfaces=org.freedesktop.impl.portal.FileChooser;org.freedesktop.impl.portal.AppChooser;org.freedesktop.impl.portal.Print;org.freedesktop.impl.portal.Notification;org.freedesktop.impl.portal.Inhibit;org.freedesktop.impl.portal.Access;org.freedesktop.impl.portal.Account;org.freedesktop.impl.portal.Email;org.freedesktop.impl.portal.DynamicLauncher;org.freedesktop.impl.portal.Lockdown;org.freedesktop.impl.portal.Settings;org.freedesktop.impl.portal.Wallpaper;
        UseIn=gnome;Hyprland
      '';
    };
    "1password/custom_allowed_browsers" = {
      text = ''
        chrome
      '';
      mode = "0755";
    };
  };
}
