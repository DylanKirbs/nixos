{ config, lib, pkgs, ... }:

{
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Minimal login experience
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  # Audio configuration (Hyprland)
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Essential packages for Hyprland workflow
  environment.systemPackages = with pkgs; [
    # Core Wayland/Hyprland tools
    waybar               # Status bar
    rofi-wayland         # Application launcher
    dunst                # Notifications
    grim                 # Screenshot tool
    slurp                # Screen area selection
    wl-clipboard         # Clipboard utilities
    swaylock-effects     # Screen locker
    swayidle             # Idle management
    
    # Terminal and file management
    kitty                # Terminal emulator
    ranger               # TUI file manager
    
    # Media and utilities
    brightnessctl       # Brightness control
    pamixer             # Audio control
    playerctl           # Media player control
    
    # File manager (GUI fallback when needed)
    nemo
    
    # Font for waybar/rofi
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  # Enable fonts
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  # XDG portal for screen sharing, file dialogs, etc.
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Security services
  security.polkit.enable = true;
  security.pam.services.swaylock = {};
}