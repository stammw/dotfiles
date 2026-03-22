{
  config,
  pkgs,
  ...
}:
let
  waybarConfig = builtins.toJSON {
    height = 34;
    layer = "top";
    position = "top";
    margin-top = 0;
    margin-left = 0;
    margin-right = 0;
    spacing = 4;

    modules-left = [ "hyprland/workspaces" ];
    modules-center = [ "hyprland/window" ];
    modules-right = [
      "mpris"
      "group/system"
      "group/connectivity"
      "pulseaudio"
      "group/status"
      "tray"
    ];

    "hyprland/workspaces" = {
      persistent-workspaces = {
        "DP-1" = [ 1 2 3 4 5 6 7 ];
        "DP-2" = [ 8 9 10 ];
      };
      format = "{id}";
    };

    "hyprland/window" = {
      max-length = 50;
      rewrite = {
        "" = "  Hyprland";
      };
    };

    mpris = {
      format = "{status_icon} {artist} – {title}";
      format-paused = "{status_icon} {artist} – {title}";
      status-icons = {
        playing = "󰐊";
        paused = "󰏤";
        stopped = "󰓛";
      };
      max-length = 40;
      on-click = "playerctl play-pause";
    };

    "group/system" = {
      orientation = "inherit";
      modules = [ "cpu" "memory" "disk" "temperature" ];
    };

    cpu = {
      format = "  {usage}%";
      interval = 5;
      tooltip = true;
    };

    memory = {
      format = "  {percentage}%";
      tooltip-format = "{used:0.1f}G / {total:0.1f}G used";
      interval = 5;
    };

    disk = {
      format = "󰋊 {percentage_used}%";
      path = "/";
      interval = 30;
      tooltip-format = "{used} / {total} used on {path}";
    };

    temperature = {
      critical-threshold = 80;
      format = " {temperatureC}°C";
      format-critical = " {temperatureC}°C";
      tooltip = true;
    };

    "group/connectivity" = {
      orientation = "inherit";
      modules = [ "network" "bluetooth" ];
    };

    network = {
      format-wifi = "󰤨  {essid}";
      format-ethernet = "󰈀  {ifname}";
      format-disconnected = "󰤭  offline";
      tooltip-format-wifi = "Signal: {signalStrength}%\n{ipaddr}/{cidr}\nUp: {bandwidthUpBytes} Down: {bandwidthDownBytes}";
      tooltip-format-ethernet = "{ipaddr}/{cidr}\nUp: {bandwidthUpBytes} Down: {bandwidthDownBytes}";
      interval = 5;
    };

    bluetooth = {
      format = "󰂯";
      format-connected = "󰂱 {num_connections}";
      format-disabled = "󰂲";
      tooltip-format = "{status}\n{device_enumerate}";
      tooltip-format-enumerate-connected = "{device_alias} ({device_battery_percentage}%)";
      on-click = "blueman-manager";
    };

    pulseaudio = {
      format = "{icon} {volume}%";
      format-muted = "󰖁 muted";
      format-icons = {
        default = [ "󰕿" "󰖀" "󰕾" ];
        headphone = "󰋋";
      };
      tooltip-format = "{desc}\n{volume}%";
      on-click = "pwvucontrol";
      scroll-step = 2;
    };

    "group/status" = {
      orientation = "inherit";
      modules = [ "idle_inhibitor" "battery" "clock" ];
    };

    idle_inhibitor = {
      format = "{icon}";
      format-icons = {
        activated = "󰅶";
        deactivated = "󰾪";
      };
      tooltip-format-activated = "Idle inhibitor: ON";
      tooltip-format-deactivated = "Idle inhibitor: OFF";
    };

    battery = {
      interval = 30;
      states = {
        warning = 30;
        critical = 15;
      };
      format = "{icon} {capacity}%";
      format-charging = "󰂄 {capacity}%";
      format-plugged = "󰚥 {capacity}%";
      format-icons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
    };

    clock = {
      format = "  {:%H:%M}";
      format-alt = "  {:%a %d %b %Y}";
      tooltip-format = "<tt><small>{calendar}</small></tt>";
      calendar = {
        mode = "month";
        weeks-pos = "left";
        format = {
          today = "<span color='#f38ba8'><b>{}</b></span>";
          weeks = "<span color='#94e2d5'><b>W{}</b></span>";
        };
      };
    };

    tray = {
      icon-size = 16;
      spacing = 8;
    };
  };

  waybarCss = ''
    /* === Catppuccin Mocha Palette === */
    @define-color base   #1e1e2e;
    @define-color mantle #181825;
    @define-color crust  #11111b;
    @define-color surface0 #313244;
    @define-color surface1 #45475a;
    @define-color surface2 #585b70;
    @define-color text    #cdd6f4;
    @define-color subtext0 #a6adc8;
    @define-color subtext1 #bac2de;
    @define-color rosewater #f5e0dc;
    @define-color flamingo  #f2cdcd;
    @define-color pink      #f5c2e7;
    @define-color mauve     #cba6f7;
    @define-color red       #f38ba8;
    @define-color maroon    #eba0ac;
    @define-color peach     #fab387;
    @define-color yellow    #f9e2af;
    @define-color green     #a6e3a1;
    @define-color teal      #94e2d5;
    @define-color sky       #89dceb;
    @define-color sapphire  #74c7ec;
    @define-color blue      #89b4fa;
    @define-color lavender  #b4befe;

    /* === Global === */
    * {
        font-family: "FiraCode Nerd Font", "Font Awesome 6 Free";
        font-size: 13px;
        min-height: 0;
        padding: 0;
        margin: 0;
    }

    window#waybar {
        background: rgba(30, 30, 46, 0.85);
        color: @text;
        border-radius: 0;
        border: none;
    }

    tooltip {
        background: @surface0;
        border: 1px solid @surface1;
        border-radius: 8px;
        color: @text;
    }

    tooltip label {
        color: @text;
        padding: 4px;
    }

    /* === Module base styling === */
    #workspaces,
    #window,
    #mpris,
    #cpu,
    #memory,
    #disk,
    #temperature,
    #network,
    #bluetooth,
    #pulseaudio,
    #idle_inhibitor,
    #battery,
    #clock,
    #tray {
        padding: 0 12px;
        margin: 4px 0;
        border-radius: 16px;
        background: @surface0;
        color: @text;
    }

    /* === Workspaces === */
    #workspaces {
        padding: 0 4px;
        margin-left: 4px;
    }

    #workspaces button {
        padding: 0 6px;
        margin: 2px 1px;
        border-radius: 12px;
        background: transparent;
        color: @surface2;
        border: none;
        box-shadow: none;
        min-width: 20px;
        transition: all 0.2s ease;
    }

    #workspaces button:hover {
        background: alpha(@mauve, 0.2);
        color: @mauve;
        box-shadow: none;
    }

    #workspaces button.empty {
        color: @surface1;
    }

    #workspaces button.active {
        background: @mauve;
        color: @crust;
        box-shadow: none;
    }

    #workspaces button.urgent {
        background: @red;
        color: @crust;
    }

    /* === Window title === */
    #window {
        font-style: italic;
        color: @subtext1;
        background: transparent;
    }

    /* === Standalone pills === */
    #mpris {
        color: @green;
        margin-right: 0;
    }

    #pulseaudio {
        color: @peach;
    }

    #tray {
        margin-right: 4px;
    }

    /* === Group styling (connected pills) === */

    /* System group */
    #cpu {
        color: @sky;
        border-radius: 16px 0 0 16px;
        margin-right: 0;
        border-right: 1px solid @surface1;
    }
    #memory {
        color: @sapphire;
        border-radius: 0;
        margin-left: 0;
        margin-right: 0;
        border-right: 1px solid @surface1;
    }
    #disk {
        color: @lavender;
        border-radius: 0;
        margin-left: 0;
        margin-right: 0;
        border-right: 1px solid @surface1;
    }
    #temperature {
        color: @yellow;
        border-radius: 0 16px 16px 0;
        margin-left: 0;
    }

    /* Connectivity group */
    #network {
        color: @teal;
        border-radius: 16px 0 0 16px;
        margin-right: 0;
        border-right: 1px solid @surface1;
    }
    #bluetooth {
        color: @blue;
        border-radius: 0 16px 16px 0;
        margin-left: 0;
    }

    /* Status group */
    #idle_inhibitor {
        color: @flamingo;
        border-radius: 16px 0 0 16px;
        margin-right: 0;
        border-right: 1px solid @surface1;
    }
    #battery {
        color: @green;
        border-radius: 0;
        margin-left: 0;
        margin-right: 0;
        border-right: 1px solid @surface1;
    }
    #clock {
        color: @rosewater;
        border-radius: 0 16px 16px 0;
        margin-left: 0;
    }

    /* === State-based styles === */

    /* Battery states */
    #battery.charging,
    #battery.plugged {
        color: @green;
    }

    #battery.warning:not(.charging) {
        color: @yellow;
    }

    #battery.critical:not(.charging) {
        color: @red;
        animation: blink 0.5s linear infinite alternate;
    }

    /* Temperature critical */
    #temperature.critical {
        color: @red;
        animation: blink 0.5s linear infinite alternate;
    }

    /* Network disconnected */
    #network.disconnected {
        color: @surface2;
    }

    /* Pulseaudio muted */
    #pulseaudio.muted {
        color: @surface2;
    }

    /* Idle inhibitor active */
    #idle_inhibitor.activated {
        color: @yellow;
    }

    /* === Animations === */
    @keyframes blink {
        to {
            color: @red;
            background: alpha(@red, 0.2);
        }
    }
  '';
in
{
  xdg.configFile."waybar/hyprland-config" = {
    text = waybarConfig;
  };

  xdg.configFile."waybar/hyprland-style.css" = {
    text = waybarCss;
  };
}
