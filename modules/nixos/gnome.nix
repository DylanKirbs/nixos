{ ... }:
{
  flake.modules.nixos.gnome = {
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;

    services.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };
  };
}
