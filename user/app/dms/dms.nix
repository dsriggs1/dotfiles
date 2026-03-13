{
  pkgs,
  pkgs-unstable,
  config,
  userSettings,
  inputs,
  ...
}: {
  # DankMaterialShell - Complete desktop shell for Wayland compositors
  # Replaces waybar, launcher, notifications, and provides integrated desktop experience
  programs.dank-material-shell = {
    enable = true;

    # Systemd integration
    # DISABLED: We only want DMS in window managers (Hyprland), not in KDE Plasma
    # DMS will be started via compositor autostart (exec-once in Hyprland)
    systemd.enable = false;
    systemd.restartIfChanged = false;

    # System monitoring backend package
    dgop.package = inputs.dgop.packages.${pkgs.system}.default;

    # Core features
    enableSystemMonitoring = true; # CPU, Memory, Temperature monitoring
    enableVPN = true; # VPN management widget
    enableDynamicTheming = false; # Disabled - stylix handles theming
    enableAudioWavelength = true; # Audio wavelength visualization (CAVA)
    enableCalendarEvents = true; # Calendar event integration via khal
    enableClipboardPaste = true; # Clipboard history with direct paste support

    # Compositor-specific settings
    # DMS automatically detects Hyprland and configures appropriately
  };

  # Environment variables for DMS customization
  home.sessionVariables = {
    # Display & Rendering
    DMS_DISABLE_MATUGEN = "1"; # Completely disable matugen (wallpaper-based theming)
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
  # Note: DMS automatically includes required packages based on enabled features:
  # - matugen (from enableDynamicTheming)
  # - cava (from enableAudioWavelength)
  # - khal (from enableCalendarEvents)
  # - wl-clipboard (from enableClipboardPaste)
  home.packages = with pkgs; [
    # System monitoring
    lm_sensors # Hardware sensors for temperature monitoring
    psmisc # System monitoring utilities

    # Optional: GUI calendar application
    gnome-calendar # Calendar application for viewing events

    # Note: NetworkManager and Bluez are system-level packages,
    # configured in system/packages.nix
  ];

  # XDG configuration for DMS
  xdg.configFile = {
    # DMS settings configuration
    "DankMaterialShell/settings.json".text = builtins.toJSON {
      # Configuration version (DMS uses this for migrations)
      configVersion = 5;

      # Location settings for weather
      location = {
        city = "Charlotte";
        state = "NC";
        country = "US";
        latitude = 35.2271;
        longitude = -80.8431;
      };

      # Weather settings
      weather = {
        units = "imperial";
        temperatureUnit = "fahrenheit";
      };

      # Clock settings
      clock = {
        use24Hour = false; # Use 12-hour format (AM/PM)
      };

      # UI behavior
      ui = {
        closePopupsOnClickOutside = true;
        escapeKeyClosesPopups = true;
      };

      # Wallpaper management
      wallpaper = {
        managedByDMS = false; # Let hyprpaper manage wallpaper (stylix integration)
      };

      # Bar configuration
      barConfigs = [
        {
          id = "default";
          name = "Main Bar";
          enabled = true;
          position = 0; # 0 = top, 1 = bottom
          screenPreferences = ["all"]; # Show on all monitors
          showOnLastDisplay = true;

          # Left section: launcher, workspaces, focused window
          leftWidgets = [
            "launcherButton"
            "workspaceSwitcher" # Shows workspace numbers 1-9
            "focusedWindow"
          ];

          # Center section: music, clock, weather
          centerWidgets = [
            "music"
            "clock"
            "weather" # Uses Charlotte location
          ];

          # Right section: system tray and controls
          rightWidgets = [
            "systemTray"
            "clipboard"
            "cpuUsage"
            "memUsage"
            "notificationButton"
            "battery"
            "controlCenterButton"
          ];

          # Styling
          spacing = 4;
          innerPadding = 4;
          bottomGap = 0;
          transparency = 1;
          widgetTransparency = 1;
          squareCorners = false;
          noBackground = false;
          gothCornersEnabled = false;
          gothCornerRadiusOverride = false;
          gothCornerRadiusValue = 12;
          borderEnabled = false;
          borderColor = "surfaceText";
          borderOpacity = 1;
          borderThickness = 1;
          fontScale = 1.5;

          # Behavior
          autoHide = false;
          autoHideDelay = 250;
          openOnOverview = false;
          visible = true;
          popupGapsAuto = true;
          popupGapsManual = 4;
        }
      ];

      # Desktop widget instances (empty for now)
      desktopWidgetInstances = [];
    };

    # DMS session state configuration (wallpaper settings)
    # This file is located in ~/.local/state/DankMaterialShell/session.json
    # We create it via XDG state home to pre-configure wallpaper
    "../.local/state/DankMaterialShell/session.json".text = builtins.toJSON {
      # Wallpaper configuration
      wallpaperPath = "${config.stylix.image}";
      wallpaperFillMode = "PreserveAspectCrop";

      # For multi-monitor setups, you can add per-monitor wallpapers:
      # monitorWallpapers = {
      #   "DVI-I-1" = "/path/to/wallpaper1.png";
      #   "DVI-I-2" = "/path/to/wallpaper2.png";
      #   "eDP-1" = "/path/to/wallpaper3.png";
      # };
    };
  };

  # Note about Desktop Environment Integration:
  # DMS is configured to run ONLY in window managers (Hyprland, niri, etc.)
  # It will NOT run in KDE Plasma, which has its own panels.
  #
  # How it works:
  # - systemd.enable = false prevents DMS from auto-starting in all sessions
  # - DMS is started via compositor autostart (exec-once in Hyprland)
  # - When you log into KDE: No DMS (uses Plasma panels)
  # - When you log into Hyprland: DMS starts automatically
  #
  # DMS will automatically integrate with Hyprland when it detects it.
  # The bar will appear on all monitors with appropriate workspace assignments.
  #
  # After first boot into Hyprland:
  # 1. Run: dms setup (to generate Hyprland-specific configs)
  # 2. Customize bar layout in ~/.config/DankMaterialShell/
  # 3. Restart DMS: dms restart (or logout/login)
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
