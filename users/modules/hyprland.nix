{
  config,
  lib,
  pkgs,
  hostDisplayManager,
  ...
}:

lib.mkIf (hostDisplayManager == "hyprland") {
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = ",preferred,auto,1";

      exec-once = [
        "waybar"
        "dunst"
        "swaybg -i ~/Pictures/Wallpapers/pixel-pusher-d.jpg"
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

      bind = [
        "SUPER, T, exec, kitty"
        "SUPER, Q, killactive,"
        "SUPER, M, exit,"
        "SUPER, V, togglefloating,"
        "SUPER, R, exec, rofi -show drun"
        "SUPER, L, exec, swaylock-effects -f"
        # Swap focus
        "SUPER, left, movefocus, l"
        "SUPER, right, movefocus, r"
        "SUPER, up, movefocus, u"
        "SUPER, down, movefocus, d"
        # Swap workspace
        "SUPER CONTROL, right, workspace, e+1"
        "SUPER CONTROL, left, workspace, e-1"
        # Move to workspace
        "SUPER SHIFT, right, movetoworkspace, e+1"
        "SUPER SHIFT, left, movetoworkspace, e-1"
        # Misc
        ", PRINT, exec, hyprshot -m region"
      ];

      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
      ];

      windowrule = [
        "float,class:^(kitty)$,title:^(kitty)$"
        "suppressevent maximize, class:.*"
      ];

    };
  };

  # User program configs
  programs.kitty.enable = true;
  programs.rofi.enable = true;

  home.packages = with pkgs; [
    swaybg
    hyprshot
  ];
}
