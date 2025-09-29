{ config, lib, pkgs, ... }:

lib.mkIf (config.programs.hyprland.enable or false) {
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = ",preferred,auto,1";

      exec-once = [
        "waybar"
        "dunst"
        "swaybg -i ~/Pictures/Wallpapers/pixel-pusher-d.jxl"
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
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
      };

      animations.enabled = true;

      bind = [
        "SUPER, Return, exec, kitty"
        "SUPER, Q, killactive"
        "SUPER, D, exec, rofi -show drun"
        "SUPER, L, exec, swaylock"
        "SUPER, F, fullscreen"
        "SUPER, Space, togglefloating"
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
      ];
    };
  };

  # User program configs
  programs.kitty.enable = true;
  programs.rofi.enable = true;

  home.packages = with pkgs; [
    swaybg
  ];
}

