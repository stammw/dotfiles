{
  pkgs,
  lib,
  config,
  ...
}:
let
  modifier = "Mod4";
  terminal = "${pkgs.alacritty}/bin/alacritty";
  backgroundPath = "Pictures/background.jpg";
in
{
  imports = [
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    swaylock
    swaybg
    kanshi
    grim
    slurp
    wl-clipboard
    mako
    anyrun
    ulauncher
  ];

  home.file."${backgroundPath}" = {
    source = ./pillars.png;
  };

  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = true;
    wrapperFeatures.gtk = true;
    checkConfig = true;

    config = {
      modifier = "${modifier}";
      terminal = "${terminal}";
      menu = "${pkgs.ulauncher}/bin/ulauncher";

      defaultWorkspace = "1";
      seat = {
        "*" = {
          xcursor_theme = "Bibata-Modern-Ice 40";
          hide_cursor = "when-typing enable";
        };
      };
      startup = [
        {
          command = "${pkgs.kanshi}/bin/kanshi";
          always = true;
        }
        {
          command = "${pkgs.swaybg}/bin/swaybg --output '*' -m fill --image '${config.home.homeDirectory}/${backgroundPath}'";
          always = true;
        }
      ];

      input = {
        "*" = {
          xkb_variant = "altgr-intl";
          xkb_options = "caps:escape";
        };
      };

      bars = [
        { command = "${pkgs.waybar}/bin/waybar"; }
      ];

      window = {
        hideEdgeBorders = "smart";
        titlebar = false;
      };

      gaps = {
        inner = 4;
        outer = 0;
        smartBorders = "on";
        smartGaps = true;
      };

      keybindings = lib.mkOptionDefault {
        "${modifier}+t" = "exec ${terminal}";
        "${modifier}+shift+r" = "exec ${pkgs.kanshi}/bin/kanshictl reload";
        "${modifier}+w" = "exec ${pkgs.firefox}/bin/firefox";
        "${modifier}+shift+f" = "floating toggle";
        "${modifier}+shift+grave" =
          "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp -d)\" - | ${pkgs.wl-clipboard}/bin/wl-copy -t image/png";
        "${modifier}+p" = "exec 1password --quick-access";
      };

      colors = {
        focused = {
          border = "#4c7899";
          background = "#2222221A";
          text = "#ffffff";
          indicator = "#2e9ef4";
          childBorder = "#285577";
        };
        unfocused = {
          border = "#333333";
          background = "#22222219";
          text = "#888888";
          indicator = "#292d2e";
          childBorder = "#222222";
        };
      };
    };

    extraConfig = ''
      workspace 1
      for_window [app_id="org.pulseaudio.pavucontrol"] floating enable
      for_window [class="1Password"] floating enable
    '';
  };

  programs.wofi = {
    enable = true;
  };

  xsession = {
    enable = true;
    scriptPath = ".hm-xsession";
    windowManager.command = ''
      export MOZ_ENABLE_WAYLAND=1
      export NIXOS_OZONE_WL=1
      export XDG_SESSION_TYPE=wayland
      export XDG_SESSION_DESKTOP=sway
      export XDG_CURRENT_DESKTOP=sway
      export CLUTTER_BACKEND=wayland
      export QT_QPA_PLATFORM=wayland-egl
      export ECORE_EVAS_ENGINE=wayland-egl
      export ELM_ENGINE=wayland_egl
      export SDL_VIDEODRIVER=wayland
      export _JAVA_AWT_WM_NONREPARENTING=1
      export NO_AT_BRIDGE=1
      export XKB_DEFAULT_LAYOUT=us
      export XKB_DEFAULT_VARIANT=altgr-intl
    '';
  };

  services.kanshi = {
    enable = true;
    systemdTarget = "";

    profiles = {
      undocked = {
        outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            mode = "1920x1200";
          }
        ];
      };
      docked_one_screen = {
        outputs = [
          {
            criteria = "eDP-1";
            status = "disable";
          }
          {
            status = "enable";
            criteria = "Dell Inc. DELL U4025QW CY6XM04";
            mode = "5120x2160";

          }
        ];
      };
      bye_brain_one = {
        outputs = [
          {
            status = "enable";
            criteria = "Dell Inc. DELL U4025QW CY6XM04";
            position = "0,2160";
            mode = "5120x2160";

          }
        ];
      };
      bye_brain_stacked = {
        outputs = [
          {
            criteria = "Dell Inc. DELL U4021QW BCLM9H3";
            status = "enable";
            position = "0,0";
            mode = "5120x2160";
          }
          {
            status = "enable";
            criteria = "Dell Inc. DELL U4025QW CY6XM04";
            position = "0,2160";
            mode = "5120x2160";

          }
        ];
      };
      bye_brain_full = {
        outputs = [

          {
            criteria = "Dell Inc. DELL U4021QW BCLM9H3";
            status = "enable";
            position = "0,0";
            mode = "5120x2160";
          }
          {
            status = "enable";
            criteria = "Dell Inc. DELL U4025QW CY6XM04";
            position = "0,2160";
            mode = "5120x2160";

          }
          {
            criteria = "Dell Inc. DELL U2913WM 9DD4K669091L";
            status = "enable";
            position = "5120,180";
            mode = "2560x1080";
            transform = "90";
          }
        ];
      };
      docked = {
        outputs = [
          {
            criteria = "eDP-1";
            status = "disable";
          }
          {
            criteria = "Dell Inc. DELL U4021QW BCLM9H3";
            status = "enable";
            position = "0,0";
            mode = "5120x2160";
          }
          {
            status = "enable";
            criteria = "Dell Inc. DELL U4025QW CY6XM04";
            position = "0,2160";
            mode = "5120x2160";

          }
        ];
      };
    };
  };
}
