{
  pkgs,
  pkgs-unstable,
  config,
  userSettings,
  ...
}: {
  # DankMaterialShell - Complete desktop shell for Wayland compositors
  # Replaces waybar, launcher, notifications, and provides integrated desktop experience
  programs.dank-material-shell = {
    enable = true;

    # Core features
    enableSystemMonitoring = true; # CPU, Memory, Temperature monitoring
    enableVpn = true; # VPN management widget
    enableDynamicTheming = true; # Wallpaper-based color schemes via matugen
    enableAudioVisualization = true; # Audio visualizer (CAVA)
    enableCalendar = true; # Calendar integration
    enableClipboard = true; # Clipboard manager

    # Compositor-specific settings
    # DMS automatically detects Hyprland and configures appropriately
  };

  # Environment variables for DMS customization
  home.sessionVariables = {
    # Display & Rendering
    # DMS_DISABLE_MATUGEN = "false"; # Keep dynamic theming enabled
    # DMS_DISABLE_CAVA = "false"; # Keep audio visualizer enabled
    # DMS_DISABLE_LAYER = "false"; # Keep layer effects for visual quality

    # Layer positioning (adjust if needed for multi-monitor setup)
    # DMS_DANKBAR_LAYER = "top"; # Bar on top layer
    # DMS_POPOUT_LAYER = "overlay"; # Popouts above windows
    # DMS_MODAL_LAYER = "overlay"; # Modals above windows
    # DMS_OSD_LAYER = "overlay"; # On-screen display overlays
    # DMS_NOTIFICATION_LAYER = "top"; # Notifications on top

    # System tray customization
    # Hide specific tray icons (comma-separated list of IDs)
    # DMS_HIDE_TRAYIDS = "";

    # Battery configuration for laptops with multiple batteries
    # DMS_PREFERRED_BATTERY = "BAT0"; # Force specific battery device
  };

  # Additional packages for DMS functionality
  home.packages = with pkgs; [
    # Required for dynamic theming
    pkgs-unstable.matugen # Wallpaper-based color scheme generator

    # Audio visualization
    cava # Console-based audio visualizer

    # System monitoring
    lm_sensors # Hardware sensors for temperature monitoring
    psmisc # System monitoring utilities

    # Clipboard management
    wl-clipboard # Wayland clipboard utilities

    # Network management
    networkmanager # For wifi widget
    bluez # For bluetooth widget
    bluez-tools # Additional bluetooth utilities

    # Optional: Calendar integration
    gnome-calendar # Calendar application for calendar widget

    # Launcher dependencies (DMS has built-in launcher)
    # No additional packages needed - DMS launcher is built-in
  ];

  # XDG configuration for DMS
  xdg.configFile = {
    # DMS will create its config directory at ~/.config/DankMaterialShell/
    # After first run, you can customize:
    # - Bar layout and widget positioning
    # - App launcher appearance
    # - Theme overrides
    # - Plugin configuration

    # Example: Custom DMS configuration (uncomment to use)
    # "DankMaterialShell/config.json".text = builtins.toJSON {
    #   bar = {
    #     layout = "left-workspaces-center-clock-right-widgets";
    #     widgets = {
    #       left = [ "launcher" "workspaces" ];
    #       center = [ "clock" ];
    #       right = [ "volume" "bluetooth" "wifi" "battery" "system-monitor" ];
    #     };
    #   };
    # };
  };

  # Note about Hyprland integration:
  # DMS will automatically integrate with Hyprland when it detects it.
  # The bar will appear on all monitors with appropriate workspace assignments.
  #
  # After enabling DMS, you should:
  # 1. Disable waybar in hyprland.nix (comment out "waybar" in exec-once)
  # 2. Run: dms setup
  # 3. Customize bar layout in ~/.config/DankMaterialShell/
  #
  # DMS Features included by default:
  # - App launcher (far left of bar) - Spotlight-style search
  # - Workspace indicator - Shows all workspaces across monitors
  # - Clock with calendar dropdown - Click to open calendar
  # - Volume widget - Control audio, click for mixer
  # - Bluetooth widget - Manage BT devices
  # - WiFi widget - Network management
  # - Battery indicator - Battery status and percentage
  # - System monitoring - CPU, Memory, Temperature with clickable popups
  # - Multi-monitor support - Bar on each monitor with proper workspace routing
}
