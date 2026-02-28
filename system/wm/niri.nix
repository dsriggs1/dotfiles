{
  pkgs,
  inputs,
  ...
}: {
  # Import niri home-manager module
  imports = [
    inputs.niri.nixosModules.niri
  ];

  # Enable niri at system level
  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };

  # Enable required services for niri
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;

  # XDG Desktop Portal for screen sharing, etc.
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
    ];
  };

  # Enable dconf (required for GTK apps)
  programs.dconf.enable = true;

  # Notification daemon
  services.dbus.enable = true;
}
