{pkgs, ...}: {
  # Display Configuration - Supports both X11 and Wayland
  # X11: autorandr - System-level service (profiles configured in home-manager)
  # Wayland: kanshi - Configured in home-manager (user/app/kanshi/kanshi.nix)

  # ============================================================
  # X11 Support - autorandr (system-level service only)
  # ============================================================
  # Note: Profiles and hooks are configured in user/app/autorandr/autorandr.nix
  services.autorandr = {
    enable = true;
  };

  # Enable X11 display manager session commands for DisplayLink support
  # This ensures DisplayLink adapters are initialized properly
  services.xserver.displayManager.sessionCommands = ''
    # Set DisplayLink provider output source
    ${pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 2 0 2>/dev/null || true

    # Run autorandr to detect and configure displays
    ${pkgs.autorandr}/bin/autorandr --change --default default
  '';

  # ============================================================
  # Wayland Support - kanshi
  # ============================================================
  # Note: kanshi is configured per-user in home-manager
  # This just ensures the package is available

  # Install display configuration tools system-wide
  environment.systemPackages = with pkgs; [
    autorandr # X11
    kanshi # Wayland
    wlr-randr # Wayland equivalent of xrandr (for wlroots compositors)
  ];
}
