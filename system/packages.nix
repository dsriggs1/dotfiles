{
  pkgs,
  pkgs-stable,
  inputs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  # Minimal system packages - essential tools and system services only
  # User applications and CLI tools are managed in home.nix for portability
  environment.systemPackages = with pkgs; [
    # Display server & session management
    xorg.xorgserver
    xorg.xinit
    lightdm

    # System services & daemons
    bluez # Bluetooth daemon
    polkit_gnome # Authentication agent
    gvfs # Virtual filesystems
    xdg-desktop-portal # Portal for sandboxed apps
    xdg-user-dirs # XDG user directories
    networkmanagerapplet # Network management

    # Media server (system service)
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg

    # Emergency/bootstrap tools (available before home-manager)
    vim # Fallback editor
    wget # Bootstrap downloads
    git # Clone dotfiles
    unzip # Extract archives

    # Hardware/system utilities
    brightnessctl # Hardware brightness control
    man-pages # System documentation
  ];

  fonts.packages = with pkgs; [
    font-awesome
    papirus-icon-theme
  ];
}
