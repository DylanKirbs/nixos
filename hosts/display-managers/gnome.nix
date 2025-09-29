{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./common.nix
  ];

  hostDisplayManager = "gnome";

  # Enable X11 and GNOME
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Audio configuration (GNOME/Wayland)
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # GNOME-specific packages
  environment.systemPackages = with pkgs; [
    libreoffice-qt
    hunspell
    hunspellDicts.en_GB-ise
  ];
}
