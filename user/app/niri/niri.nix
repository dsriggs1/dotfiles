{
  pkgs,
  lib,
  config,
  keybindings,
  ...
}: {
  # Enable niri window manager
  programs.niri.settings = {
    # Input configuration
    input = {
      keyboard = {
        xkb = {
          layout = "us";
        };
      };

      touchpad = {
        tap = true;
        natural-scroll = true;
        dwt = true;
      };

      mouse = {
        natural-scroll = false;
      };

      focus-follows-mouse = {
        enable = false;
      };
    };

    # Output configuration (monitors)
    outputs = {
      # Left external monitor (primary)
      "DVI-I-1" = {
        mode = {
          width = 1920;
          height = 1080;
          refresh = 60.0;
        };
        position = {
          x = 0;
          y = 0;
        };
      };

      # Right external monitor
      "DVI-I-2" = {
        mode = {
          width = 1920;
          height = 1080;
          refresh = 60.0;
        };
        position = {
          x = 1920;
          y = 0;
        };
      };

      # Laptop screen (rightmost when docked)
      "eDP-1" = {
        mode = {
          width = 2256;
          height = 1504;
          refresh = 60.0;
        };
        position = {
          x = 3840;
          y = 0;
        };
      };
    };

    # Layout configuration
    layout = {
      gaps = 10;
      center-focused-column = "never";
      preset-column-widths = [
        {proportion = 0.33333;}
        {proportion = 0.5;}
        {proportion = 0.66667;}
      ];
      default-column-width = {proportion = 1.0;};

      focus-ring = {
        enable = true;
        width = 4;
      };

      border = {
        enable = false;
      };
    };

    # Spawn programs at startup
    spawn-at-startup = [
      {command = ["dms" "run"];}
      {command = ["sh" "-c" "sleep 3 && dms ipc call wallpaper set ${config.stylix.image}"];}
    ];

    # Environment variables
    environment = {
      DISPLAY = ":0";
    };

    # Key bindings
    binds = let
      # Convert keybinding string to niri format
      # "Meta+Shift+S" -> {mods = ["Mod" "Shift"]; key = "S";}
      parseKey = binding: let
        parts = lib.splitString "+" binding;
        mods = map (m:
          if m == "Meta"
          then "Mod"
          else if m == "Ctrl"
          then "Ctrl"
          else m)
        (lib.filter (x: lib.elem x ["Meta" "Shift" "Ctrl" "Alt"]) parts);
        key = lib.last (lib.filter (x: !(lib.elem x ["Meta" "Shift" "Ctrl" "Alt"])) parts);
      in {
        inherit mods key;
      };

      # Helper to create bind entry
      mkBind = binding: action: let
        parsed = parseKey binding;
        keyStr =
          if parsed.mods == []
          then parsed.key
          else "${lib.concatStringsSep "+" parsed.mods}+${parsed.key}";
      in
        lib.nameValuePair keyStr action;
    in
      lib.listToAttrs [
        # --- Window Focus (vim-style navigation) ---
        (mkBind keybindings.focusLeft {action.focus-column-left = {};})
        (mkBind keybindings.focusRight {action.focus-column-right = {};})
        (mkBind keybindings.focusDown {action.focus-window-down = {};})
        (mkBind keybindings.focusUp {action.focus-window-up = {};})

        # --- Window Actions ---
        (mkBind keybindings.windowClose {action.close-window = {};})
        (mkBind keybindings.windowFullscreen {action.fullscreen-window = {};})
        # Note: Meta+T (windowFloat) -> maximize-column (niri doesn't have traditional float)
        (mkBind keybindings.windowFloat {action.maximize-column = {};})

        # --- App Launchers ---
        (mkBind keybindings.launchTerminal {action.spawn = ["alacritty"];})
        (mkBind keybindings.launchBrowser {action.spawn = ["firefox"];})
        (mkBind keybindings.launchFileManager {action.spawn = ["thunar"];})
        (mkBind keybindings.launchVscode {action.spawn = ["code"];})
        (mkBind keybindings.launchSystemMonitor {action.spawn = ["alacritty" "-e" "btop"];})
        # App runner opens DMS launcher
        (mkBind keybindings.appRunner {action.spawn = ["dms" "ipc" "launcher" "toggle"];})

        # --- Workspaces (numbered) ---
        (lib.nameValuePair "Mod+1" {action.focus-workspace = 1;})
        (lib.nameValuePair "Mod+2" {action.focus-workspace = 2;})
        (lib.nameValuePair "Mod+3" {action.focus-workspace = 3;})
        (lib.nameValuePair "Mod+4" {action.focus-workspace = 4;})
        (lib.nameValuePair "Mod+5" {action.focus-workspace = 5;})
        (lib.nameValuePair "Mod+6" {action.focus-workspace = 6;})
        (lib.nameValuePair "Mod+7" {action.focus-workspace = 7;})
        (lib.nameValuePair "Mod+8" {action.focus-workspace = 8;})
        (lib.nameValuePair "Mod+9" {action.focus-workspace = 9;})

        # --- Move window to workspaces ---
        (lib.nameValuePair "Mod+Shift+1" {action.move-column-to-workspace = 1;})
        (lib.nameValuePair "Mod+Shift+2" {action.move-column-to-workspace = 2;})
        (lib.nameValuePair "Mod+Shift+3" {action.move-column-to-workspace = 3;})
        (lib.nameValuePair "Mod+Shift+4" {action.move-column-to-workspace = 4;})
        (lib.nameValuePair "Mod+Shift+5" {action.move-column-to-workspace = 5;})
        (lib.nameValuePair "Mod+Shift+6" {action.move-column-to-workspace = 6;})
        (lib.nameValuePair "Mod+Shift+7" {action.move-column-to-workspace = 7;})
        (lib.nameValuePair "Mod+Shift+8" {action.move-column-to-workspace = 8;})
        (lib.nameValuePair "Mod+Shift+9" {action.move-column-to-workspace = 9;})

        # --- Workspace Navigation (scrolling model) ---
        # SUGGESTED ALTERNATIVE: Use Mod+Ctrl+H/L for scrolling workspaces (more consistent with vim bindings)
        (lib.nameValuePair "Mod+Ctrl+H" {action.focus-workspace-up = {};})
        (lib.nameValuePair "Mod+Ctrl+L" {action.focus-workspace-down = {};})

        # Move window while scrolling workspaces
        (lib.nameValuePair "Mod+Ctrl+Shift+H" {action.move-column-to-workspace-up = {};})
        (lib.nameValuePair "Mod+Ctrl+Shift+L" {action.move-column-to-workspace-down = {};})

        # --- Volume Controls ---
        (mkBind keybindings.volumeUp {action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"];})
        (mkBind keybindings.volumeDown {action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"];})
        (mkBind keybindings.volumeMute {action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];})

        # --- Screenshots ---
        (mkBind keybindings.screenshotArea {action.spawn = ["sh" "-c" "grim -g \"$(slurp)\" - | wl-copy"];})
        (mkBind keybindings.screenshotFull {action.spawn = ["sh" "-c" "grim - | wl-copy"];})
        # Window screenshots require niri-specific window info - simplified to full screen for now
        (mkBind keybindings.screenshotWindow {action.spawn = ["sh" "-c" "grim - | wl-copy"];})

        # --- System Actions ---
        (mkBind keybindings.lockSession {action.spawn = ["loginctl" "lock-session"];})
        (mkBind keybindings.powerMenu {action.spawn = ["rofi-power-menu"];})

        # --- Window Management (additional niri-specific using vim keys) ---
        # Move windows within workspace
        (lib.nameValuePair "Mod+Shift+H" {action.move-column-left = {};})
        (lib.nameValuePair "Mod+Shift+L" {action.move-column-right = {};})
        (lib.nameValuePair "Mod+Shift+J" {action.move-window-down = {};})
        (lib.nameValuePair "Mod+Shift+K" {action.move-window-up = {};})

        # Resize (cycle through preset widths)
        (lib.nameValuePair "Mod+R" {action.switch-preset-column-width = {};})
        (lib.nameValuePair "Mod+Shift+F" {action.maximize-column = {};})
        (lib.nameValuePair "Mod+C" {action.center-column = {};})

        # --- Compositor Control ---
        (lib.nameValuePair "Mod+Shift+E" {action.quit = {};})
      ];

    # Window rules
    window-rules = [
      # Global rounded corners for all windows
      {
        geometry-corner-radius = {
          top-left = 12.0;
          top-right = 12.0;
          bottom-left = 12.0;
          bottom-right = 12.0;
        };
        clip-to-geometry = true;
      }
      {
        matches = [{app-id = "^pavucontrol$";}];
        default-column-width = {proportion = 0.33333;};
      }
      {
        matches = [{app-id = "^org.qalculate.qalculate-gtk$";}];
        default-column-width = {proportion = 0.33333;};
      }
      {
        matches = [{title = "Picture-in-Picture";}];
        default-column-width = {proportion = 0.25;};
      }
    ];

    # Cursor configuration
    cursor = {
      size = 24;
    };

    # Prefer no client-side decorations for cleaner look
    prefer-no-csd = true;

    # Screenshot path
    screenshot-path = "~/Pictures/Screenshots/screenshot-%Y-%m-%d-%H-%M-%S.png";

    # Animations - playful, bouncy configuration
    animations = {
      slowdown = 2.0;  # Slow down all animations to half speed

      workspace-switch = {
        spring = {
          damping-ratio = 0.8;  # Some bounce!
          stiffness = 800;
          epsilon = 0.0001;
        };
      };

      window-movement = {
        spring = {
          damping-ratio = 0.7;  # Even more bounce
          stiffness = 700;
          epsilon = 0.0001;
        };
      };

      horizontal-view-movement = {
        spring = {
          damping-ratio = 0.8;
          stiffness = 800;
          epsilon = 0.0001;
        };
      };

      window-open = {
        spring = {
          damping-ratio = 0.75;
          stiffness = 900;
          epsilon = 0.0001;
        };
      };

      window-close = {
        spring = {
          damping-ratio = 0.75;
          stiffness = 900;
          epsilon = 0.0001;
        };
      };
    };

    # Debug options (disabled for production)
    debug = {
      # disable-direct-scanout = false; # Default is false, so we can omit it
    };
  };

  # Minimal packages - only what's not already installed elsewhere
  home.packages = with pkgs; [
    jq # JSON processor (for potential window-aware screenshot scripts)
    # Note: rofi (already in home.nix) now includes Wayland support
  ];
}
