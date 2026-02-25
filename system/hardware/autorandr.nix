{pkgs, ...}: {
  # Display Configuration - Supports both X11 and Wayland
  # X11: autorandr - Automatic display configuration using xrandr
  # Wayland: kanshi - Automatic display configuration for Wayland compositors

  # ============================================================
  # X11 Support - autorandr
  # ============================================================
  services.autorandr = {
    enable = true;

    # Hooks to run after profile switch
    hooks = {
      postswitch = {
        "notify-user" = ''
          ${pkgs.libnotify}/bin/notify-send -u low "Display" "Switched to profile $AUTORANDR_CURRENT_PROFILE"
        '';
        # Restart compositor if running (for qtile/i3/etc)
        "restart-compositor" = ''
          if ${pkgs.procps}/bin/pgrep -x picom > /dev/null; then
            ${pkgs.procps}/bin/pkill picom
            ${pkgs.picom}/bin/picom -b &
          fi
        '';
        # Fix wallpaper after display change
        "fix-wallpaper" = ''
          if [ -f ~/.config/stylix/wallpaper ]; then
            ${pkgs.feh}/bin/feh --bg-scale ~/.config/stylix/wallpaper 2>/dev/null || true
          fi
        '';
      };
    };
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
