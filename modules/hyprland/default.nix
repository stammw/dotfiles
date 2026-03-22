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
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
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


  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "$mod" = "SUPER";

      general = {
        gaps_in = 4;
        gaps_out = 0;
        border_size = 2;
        "col.active_border" = "rgb(285577)";
        "col.inactive_border" = "rgb(222222)";
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
        pseudotile = true;
        preserve_split = true;
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };

      animations = {
        enabled = true;
        animation = [
          "windows, 1, 3, default"
          "windowsOut, 1, 3, default, popin 80%"
          "fade, 1, 3, default"
          "workspaces, 1, 3, default"
          "border, 1, 5, default"
          "borderangle, 1, 4, default"
        ];
      };

      env = [
        "XCURSOR_THEME,Bibata-Modern-Ice"
        "XCURSOR_SIZE,35"
        "GTK_THEME,Adwaita:dark"
      ];

      bind = [
        "$mod, T, exec, ${terminal}"
        "$mod, Return, exec, ${terminal}"
        "$mod, W, exec, ${pkgs.firefox}/bin/firefox"
        "$mod, D, exec, ${pkgs.fuzzel}/bin/fuzzel"
        "$mod, Q, killactive,"
        "$mod SHIFT, F, togglefloating,"
        "$mod, P, exec, 1password --quick-access"
        "$mod SHIFT, grave, exec, ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp -d)\" - | ${pkgs.wl-clipboard}/bin/wl-copy -t image/png"

        # Focus
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"
        "$mod, Left, movefocus, l"
        "$mod, Right, movefocus, r"
        "$mod, Up, movefocus, u"
        "$mod, Down, movefocus, d"

        # Move windows
        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, L, movewindow, r"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, J, movewindow, d"
        "$mod SHIFT, Left, movewindow, l"
        "$mod SHIFT, Right, movewindow, r"
        "$mod SHIFT, Up, movewindow, u"
        "$mod SHIFT, Down, movewindow, d"

        # Workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        # Move to workspace
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        # Fullscreen
        "$mod, F, fullscreen, 0"

        # Session
        "$mod SHIFT, E, exec, ${power-menu}"
      ];

      # Move/resize with mouse
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      windowrule = [
        "border_size 0, match:workspace w[1]"
        "match:class org.pulseaudio.pavucontrol, float on"
        "match:class 1Password, float on"
      ];

      exec-once = [
        "${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --components=secrets"
        "${pkgs.swaybg}/bin/swaybg --output 'DP-1' -m fill --image '${config.home.homeDirectory}/${wallpaperDir}/${horizontalWallpaper}'"
        "${pkgs.swaybg}/bin/swaybg --output 'DP-2' -m fill --image '${config.home.homeDirectory}/${wallpaperDir}/${verticalWallpaper}'"
        "${pkgs.kanshi}/bin/kanshi"
        "${pkgs.waybar}/bin/waybar -c ${config.xdg.configHome}/waybar/hyprland-config -s ${config.xdg.configHome}/waybar/hyprland-style.css"
      ];
    };
  };

}
