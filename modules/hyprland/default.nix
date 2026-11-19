{
  pkgs,
  config,
  ...
}:
let
  terminal = "${pkgs.alacritty}/bin/alacritty";
  wallpaperDir = "Pictures/wallpapers";
  horizontalWallpaper = "pillars.png";
  verticalWallpaper = "vertical.jpg";
  power-menu = pkgs.writeShellScript "power-menu" ''
    choice=$(echo -e "🔒 Lock\n🚪 Logout\n🔄 Restart\n⏻ Shutdown" | ${pkgs.fuzzel}/bin/fuzzel --dmenu --prompt "")
    case $choice in
      "🔒 Lock") hyprlock ;;
      "🚪 Logout") hyprctl dispatch exit ;;
      "🔄 Restart") systemctl reboot ;;
      "⏻ Shutdown") systemctl poweroff ;;
    esac
  '';
in
{
  imports = [
    ./waybar.nix
  ];

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        grace = 5;
      };
      background = {
        monitor = "";
        path = "${config.home.homeDirectory}/${wallpaperDir}/${horizontalWallpaper}";
        blur_passes = 3;
        blur_size = 8;
      };
      input-field = {
        monitor = "";
        size = "300, 60";
        outline_thickness = 2;
        dots_size = 0.25;
        dots_spacing = 0.15;
        outer_color = "rgb(45, 47, 90)";
        inner_color = "rgb(30, 30, 46)";
        font_color = "rgb(205, 214, 244)";
        check_color = "rgb(203, 166, 247)";
        fail_color = "rgb(243, 139, 168)";
        fade_on_empty = true;
        placeholder_text = "";
        position = "0, -20";
        halign = "center";
        valign = "center";
      };
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 600;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  home.file."${wallpaperDir}/${horizontalWallpaper}".source = ../../wallpapers/${horizontalWallpaper};
  home.file."${wallpaperDir}/${verticalWallpaper}".source = ../../wallpapers/${verticalWallpaper};
  home.file."${wallpaperDir}/nebula_vertical.jpg".source = ../../wallpapers/nebula_vertical.jpg;

  systemd.user.services.waybar-hyprland = {
    Unit = {
      Description = "Waybar for Hyprland";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.waybar}/bin/waybar -c ${config.xdg.configHome}/waybar/hyprland-config -s ${config.xdg.configHome}/waybar/hyprland-style.css";
      Restart = "on-failure";
      RestartSec = 2;
    };
  };

  services.swaync = {
    enable = true;
    settings = {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      control-center-layer = "top";
      layer-shell = true;
      cssPriority = "application";
      control-center-margin-top = 8;
      control-center-margin-bottom = 8;
      control-center-margin-right = 8;
      control-center-width = 400;
      notification-icon-size = 48;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      timeout = 10;
      timeout-low = 5;
      timeout-critical = 0;
      fit-to-screen = true;
      notification-window-width = 400;
      keyboard-shortcuts = true;
      image-visibility = "when-available";
      transition-time = 200;
      hide-on-clear = false;
      hide-on-action = true;
      widgets = [
        "inhibitors"
        "title"
        "dnd"
        "notifications"
      ];
      widget-config = {
        inhibitors = {
          text = "Inhibitors";
          button-text = "Clear All";
          clear-all-button = true;
        };
        title = {
          text = "Notifications";
          clear-all-button = true;
          button-text = "Clear All";
        };
        dnd = {
          text = "Do Not Disturb";
        };
      };
    };
    style = ''
      /* Override swaync CSS variables with Catppuccin Mocha */
      :root {
        --cc-bg: rgba(30, 30, 46, 0.95);
        --noti-border-color: rgba(69, 71, 90, 0.8);
        --noti-bg: 49, 50, 68;
        --noti-bg-alpha: 1;
        --noti-bg-darker: rgb(30, 30, 46);
        --noti-bg-hover: rgb(69, 71, 90);
        --noti-bg-focus: rgba(69, 71, 90, 0.6);
        --noti-close-bg: rgb(69, 71, 90);
        --noti-close-bg-hover: rgb(243, 139, 168);
        --text-color: rgb(205, 214, 244);
        --text-color-disabled: rgb(166, 173, 200);
        --bg-selected: rgb(203, 166, 247);
        --border-radius: 12px;
        --border: 1px solid rgba(69, 71, 90, 0.8);
        --notification-shadow: 0 0 8px rgba(0, 0, 0, 0.4);
      }

      * {
        font-family: "FiraCode Nerd Font", "Font Awesome 6 Free";
        font-size: 13px;
      }

      /* Notification popup */
      .notification-row {
        outline: none;
      }

      .notification-row:focus,
      .notification-row:hover {
        background: transparent;
      }

      .notification {
        border-radius: var(--border-radius);
        margin: 4px 8px;
        padding: 0;
        background: transparent;
        box-shadow: var(--notification-shadow);
      }

      .notification-content {
        background: rgba(var(--noti-bg), var(--noti-bg-alpha));
        border-radius: var(--border-radius);
        border: var(--border);
        padding: 12px 16px;
      }

      .notification-default-action {
        border-radius: var(--border-radius);
        padding: 0;
        margin: 0;
        background: transparent;
      }

      .notification-default-action:hover {
        background: var(--noti-bg-hover);
        border-radius: var(--border-radius);
      }

      .close-button {
        background: var(--noti-close-bg);
        color: var(--text-color);
        border-radius: 50%;
        margin: 4px;
        padding: 2px;
        min-width: 24px;
        min-height: 24px;
      }

      .close-button:hover {
        background: var(--noti-close-bg-hover);
        color: #11111b;
      }

      .summary {
        font-size: 14px;
        font-weight: bold;
        color: var(--text-color);
        margin-bottom: 4px;
      }

      .body {
        font-size: 13px;
        color: var(--text-color-disabled);
      }

      .notification-action {
        background: rgba(69, 71, 90, 0.6);
        border-radius: 8px;
        margin: 4px 2px;
        padding: 6px 12px;
        color: var(--text-color);
      }

      .notification-action:hover {
        background: #cba6f7;
        color: #11111b;
      }

      /* Critical notifications */
      .critical .notification-content {
        border: 1px solid rgba(243, 139, 168, 0.8);
      }

      /* Low urgency */
      .low .notification-content {
        border: 1px solid rgba(69, 71, 90, 0.4);
      }

      /* Control center */
      .control-center {
        background: var(--cc-bg);
        border: 1px solid rgba(69, 71, 90, 0.8);
        border-radius: var(--border-radius);
      }

      .control-center .notification-row .notification-background .notification {
        margin: 4px 0;
      }

      .widget-title {
        margin: 8px;
        color: var(--text-color);
        font-size: 14px;
        font-weight: bold;
      }

      .widget-title > button {
        background: #cba6f7;
        color: #11111b;
        border-radius: 8px;
        padding: 4px 12px;
      }

      .widget-title > button:hover {
        background: #89b4fa;
      }

      .widget-dnd > switch:checked {
        background: #cba6f7;
      }

      .widget-inhibitors > button {
        background: #f38ba8;
        color: #11111b;
        border-radius: 8px;
        padding: 4px 12px;
      }

      .widget-inhibitors > button:hover {
        background: #eba0ac;
      }
    '';
  };

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";

    settings = {
      mod = {
        _var = "SUPER";
      };

      env = [
        {
          _args = [
            "XCURSOR_THEME"
            "Bibata-Modern-Ice"
          ];
        }
        {
          _args = [
            "XCURSOR_SIZE"
            "35"
          ];
        }
        {
          _args = [
            "GTK_THEME"
            "Adwaita:dark"
          ];
        }
        {
          _args = [
            "ADW_DISABLE_PORTAL"
            "1"
          ];
        }
      ];

      config = {
        general = {
          gaps_in = 4;
          gaps_out = 0;
          border_size = 2;
          col = {
            active_border = "rgb(285577)";
            inactive_border = "rgb(222222)";
          };
          layout = "dwindle";
        };

        decoration = {
          rounding = 8;
        };

        input = {
          kb_layout = "us";
          kb_variant = "altgr-intl";
          kb_options = "caps:escape";
        };

        dwindle = {
          preserve_split = true;
        };

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };

        animations = {
          enabled = true;
        };
      };

      animation = [
        {
          leaf = "windows";
          enabled = true;
          speed = 3;
          bezier = "default";
        }
        {
          leaf = "windowsOut";
          enabled = true;
          speed = 3;
          bezier = "default";
          style = "popin 80%";
        }
        {
          leaf = "fade";
          enabled = true;
          speed = 3;
          bezier = "default";
        }
        {
          leaf = "workspaces";
          enabled = true;
          speed = 3;
          bezier = "default";
        }
        {
          leaf = "border";
          enabled = true;
          speed = 5;
          bezier = "default";
        }
        {
          leaf = "borderangle";
          enabled = true;
          speed = 4;
          bezier = "default";
        }
      ];

      workspace_rule = [
        {
          workspace = "1";
          monitor = "DP-1";
          default = true;
        }
        {
          workspace = "2";
          monitor = "DP-1";
        }
        {
          workspace = "3";
          monitor = "DP-1";
        }
        {
          workspace = "4";
          monitor = "DP-1";
        }
        {
          workspace = "5";
          monitor = "DP-1";
        }
        {
          workspace = "6";
          monitor = "DP-1";
        }
        {
          workspace = "7";
          monitor = "DP-1";
        }
        {
          workspace = "8";
          monitor = "DP-2";
          default = true;
        }
        {
          workspace = "9";
          monitor = "DP-2";
        }
        {
          workspace = "10";
          monitor = "DP-2";
        }
      ];

      window_rule = [
        {
          match = {
            workspace = "w[1]";
          };
          border_size = 0;
        }
        {
          match = {
            class = "org.pulseaudio.pavucontrol";
          };
          float = true;
        }
        {
          match = {
            class = "1password";
          };
          float = true;
          center = true;
        }
        {
          match = {
            class = "tidal-hifi";
          };
          float = true;
          center = true;
          size = "60% 80%";
        }
      ];
    };

    extraConfig = ''
      -- Keybindings
      hl.bind(mod .. " + T", hl.dsp.exec_cmd("${terminal}"))
      hl.bind(mod .. " + Return", hl.dsp.exec_cmd("${terminal}"))
      hl.bind(mod .. " + W", hl.dsp.exec_cmd("${pkgs.firefox}/bin/firefox"))
      hl.bind(mod .. " + D", hl.dsp.exec_cmd("${pkgs.fuzzel}/bin/fuzzel"))
      hl.bind(mod .. " + Q", hl.dsp.window.close())
      hl.bind(mod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))
      hl.bind(mod .. " + P", hl.dsp.exec_cmd("1password --quick-access"))
      hl.bind(mod .. " + N", hl.dsp.exec_cmd("${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw"))
      hl.bind(mod .. " + SHIFT + grave", hl.dsp.exec_cmd('${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -d)" - | ${pkgs.wl-clipboard}/bin/wl-copy -t image/png'))

      -- Focus
      hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left" }))
      hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))
      hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up" }))
      hl.bind(mod .. " + J", hl.dsp.focus({ direction = "down" }))
      hl.bind(mod .. " + left", hl.dsp.focus({ direction = "left" }))
      hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
      hl.bind(mod .. " + up", hl.dsp.focus({ direction = "up" }))
      hl.bind(mod .. " + down", hl.dsp.focus({ direction = "down" }))

      -- Move windows
      hl.bind(mod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
      hl.bind(mod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
      hl.bind(mod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
      hl.bind(mod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
      hl.bind(mod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
      hl.bind(mod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
      hl.bind(mod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
      hl.bind(mod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))

      -- Workspaces
      for i = 1, 9 do
        hl.bind(mod .. " + " .. i, hl.dsp.focus({ workspace = i }))
        hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
      end
      hl.bind(mod .. " + 0", hl.dsp.focus({ workspace = 10 }))
      hl.bind(mod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

      -- Fullscreen
      hl.bind(mod .. " + F", hl.dsp.window.fullscreen())

      -- Session
      hl.bind(mod .. " + SHIFT + E", hl.dsp.exec_cmd("${power-menu}"))

      -- Move/resize with mouse
      hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
      hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

      -- Autostart
      hl.on("hyprland.start", function()
        hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP GTK_THEME ADW_DISABLE_PORTAL")
        hl.exec_cmd("${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --components=secrets")
        hl.exec_cmd("${pkgs.swaybg}/bin/swaybg --output 'DP-1' -m fill --image '${config.home.homeDirectory}/${wallpaperDir}/${horizontalWallpaper}'")
        hl.exec_cmd("${pkgs.swaybg}/bin/swaybg --output 'DP-2' -m fill --image '${config.home.homeDirectory}/${wallpaperDir}/${verticalWallpaper}'")
        hl.exec_cmd("${pkgs.kanshi}/bin/kanshi")
        hl.exec_cmd("systemctl --user restart waybar-hyprland")
      end)
    '';
  };

}
