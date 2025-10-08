{
  config,
  lib,
  pkgs,
  hostDisplayManager,
  ...
}:
lib.mkIf (hostDisplayManager == "hyprland") {

  gtk = {
    enable = true;

    theme = {
      package = pkgs.catppuccin-gtk;
      name = "Catppuccin-Mocha-Standard-Blue-Dark";
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = ",preferred,auto,1";

      exec-once = [
        "waybar"
        "dunst"
        "swayidle -w"
        "wl-paste --watch"
      ];

      input = {
        kb_layout = "za";
        follow_mouse = 1;
        touchpad.natural_scroll = "yes";
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "0xff89b4fa";
        "col.inactive_border" = "0xff444444";
      };

      decoration = {
        rounding = 5;
        blur = {
          size = 8;
          passes = 2;
        };
        shadow = {
          enabled = true;
          range = 15;
          render_power = 3;
        };
      };

      animations.enabled = true;

      "$mod" = "SUPER";

      bind = [
        "$mod, space, exec, rofi -show drun"
        "$mod, T, exec, kitty"
        "$mod, M, exit,"
        "$mod, L, exec, swaylock --clock --indicator --screenshots --effect-blur 7x5 --fade-in 0.2 --grace 2 --indicator-radius 120 --indicator-thickness 8 --ring-color 89b4fa --key-hl-color fab387 --line-color 1e1e2e --inside-color 11111b --font 'JetBrainsMono Nerd Font' --text-color cdd6f4"
        # Manage windows
        "$mod, Q, killactive,"
        "$mod, V, togglefloating,"
        "$mod, F, fullscreen,"
        # Swap focus to window
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        # Move window in workspace
        "$mod ALT, left, movewindow, l"
        "$mod ALT, right, movewindow, r"
        "$mod ALT, up, movewindow, u"
        "$mod ALT, down, movewindow, d"
        # Swap focus to workspace
        "$mod CONTROL, right, workspace, +1"
        "$mod CONTROL, left, workspace, -1"
        # Move window to workspace
        "$mod SHIFT, right, movetoworkspace, +1"
        "$mod SHIFT, left, movetoworkspace, -1"
        # Misc
        ", PRINT, exec, hyprshot -m region"
      ];

      binde = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
      ];

      workspace = [
        "*, layout:dwindle"
      ];

    };
  };

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = [
          "hyprland/workspaces"
          "clock"
        ];
        modules-right = [
          "pulseaudio"
          "network"
          "battery"
          "tray"
        ];
        "clock" = {
          format = "󰥔 {:%Y-%m-%d %H:%M}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          on-click = "kitty -e calcurse";
        };
        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-muted = " ";
          format-icons = {
            headphone = " ";
            handsfree = "󰋎 ";
            headset = "󰋎 ";
            default = [
              " "
              " "
              " "
            ];
          };
          on-click = "kitty -e pulsemixer"; # or "pavucontrol";
          on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          reverse-scrolling = true;
          tooltip-format = "{descr}\nVolume: {volume}%";
        };
        "network" = {
          format-wifi = "{icon} {essid}";
          format-ethernet = " {ifname}";
          format-disconnected = " ";
          format-icons = [
            "󰤯 " # 0–20%
            "󰤟 " # 20–40%
            "󰤢 " # 40–60%
            "󰤥 " # 60–80%
            "󰤨 " # 80–100%
          ];
          tooltip-format-wifi = "SSID: {essid}\nSignal: {signalStrength}%\nIPv4: {ipaddr}";
          tooltip-format-ethernet = "Interface: {ifname}\nIPv4: {ipaddr}";
          tooltip-format-disconnected = "No connection";
          max-length = 50;
          on-click = "kitty -e nmtui";
        };
        "battery" = {
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-icons = [
            "󰁺" # 0–20%
            "󰁼" # 20–40%
            "󰁾" # 40–60%
            "󰂀" # 60–80%
            "󰁹" # 80–100%
          ];
          tooltip-format = "Capacity (%): {capacity}\nPower (W): {power}\nTime to empty: {time}\nCharge cycles: {cycles}\nHealth (%): {health}";
        };

      };
    };
    style = ''
      * {
      font-family: "JetBrainsMono Nerd Font", sans-serif;
      font-size: 14px;
      min-height: 0;
      }

      window#waybar {
      background: rgba(30, 30, 46, 0.85); /* #1e1e2e with transparency */
      border-bottom: 2px solid #89b4fa;
      color: #cdd6f4;
      padding: 0 10px;
      margin: 0 10px;
      border-radius: 8px;
      }

      #workspaces button {
      padding: 0 8px;
      margin: 4px 4px;
      background: transparent;
      border-radius: 6px;
      color: #a6adc8;
      }
      #workspaces button.focused {
      background: #89b4fa;
      color: #1e1e2e;
      font-weight: bold;
      }
      #workspaces button.urgent {
      background: #f38ba8;
      color: #181825;
      }

      #clock, #pulseaudio, #network, #battery, #tray {
      padding: 0 10px;
      margin: 4px 4px;
      background: rgba(49, 50, 68, 0.4);
      border-radius: 6px;
      }

      #battery.critical {
      color: #f38ba8;
      font-weight: bold;
      }
    '';
  };

  programs.rofi = {
    enable = true;
    theme = "catppuccin-mocha";
    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      icon-theme = "Adwaita";
    };
  };

  home.file.".config/rofi/themes/catppuccin-mocha.rasi".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/catppuccin/rofi/main/themes/catppuccin-mocha.rasi";
    sha256 = "0ikn0yc2b9cyzk4xga8mcq1j7xk2idik4wzpsibrphy8qr2pla4b";
  };

  programs.kitty.enable = true;

  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    pavucontrol
    pulsemixer
    calcurse
  ];

}
