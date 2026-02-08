{pkgs, ...}: {
  # Enable Hyprland at system level
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Enable required services for Hyprland
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;

  # XDG Desktop Portal for screen sharing, etc.
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  # Enable dconf (required for GTK apps)
  programs.dconf.enable = true;

  # Notification daemon
  services.dbus.enable = true;

  # Required for hypridle/hyprlock to work properly
  security.pam.services.hyprlock = {};
}
