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
        "$mod, Q, killactive,"
        "$mod, M, exit,"
        "$mod, V, togglefloating,"
        "$mod, L, exec, swaylock --color=\"000000\""
        "$mod, S, layoutmsg, togglesplit"
        # Swap focus
        "$mod, Tab, exec, rofi -show window"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        # Swap workspace
        "$mod CONTROL, right, workspace, e+1"
        "$mod CONTROL, left, workspace, e-1"
        # Move to workspace
        "$mod SHIFT, right, movetoworkspace, e+1"
        "$mod SHIFT, left, movetoworkspace, e-1"
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
        "*, layout:monocle"
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
      };
    };
    style = ''
      * {
      font-family: "JetBrainsMono Nerd Font", sans-serif;
      font-size: 13px;
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

  ];

}
