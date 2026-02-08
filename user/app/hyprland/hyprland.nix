{
  pkgs,
  keybindings,
  userSettings,
  config,
  ...
}: {
  imports = [
    ./hyprlock.nix
    ./hypridle.nix
    ./hyprpaper.nix
    ./hyprpicker.nix
    ./hyprshot.nix
    ./waybar.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;

    settings = let
      # Helper function to convert keybinding strings to Hyprland format
      # Input: "Meta+Shift+S" -> Output: "SUPER SHIFT, S"
      parseKey = binding: let
        # Split returns alternating strings and match lists, filter to strings only
        rawParts = builtins.split "\\+" binding;
        parts = builtins.filter (x: builtins.isString x) rawParts;
        mods = builtins.filter (x: builtins.elem x ["Meta" "Shift" "Ctrl" "Alt"]) parts;
        keyList = builtins.filter (x: !(builtins.elem x ["Meta" "Shift" "Ctrl" "Alt"])) parts;
        key = builtins.head keyList;
        modsStr = builtins.concatStringsSep " " (map (
            m:
              if m == "Meta"
              then "SUPER"
              else if m == "Ctrl"
              then "CONTROL"
              else m
          )
          mods);
      in
        if modsStr == ""
        then ", ${key}"
        else "${modsStr}, ${key}";
    in {
      # Monitor configuration
      monitor = [
        ",preferred,auto,1"
      ];

      # Autostart
      exec-once = [
        "waybar"
        "hyprpaper"
        "hypridle"
      ];

      # Input configuration
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = {
          natural_scroll = true;
        };
      };

      # General window behavior
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        layout = "dwindle";
      };

      # Decorations
      decoration = {
        rounding = 8;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
      };

      # Animations
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      # Dwindle layout
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      # Gestures
      gestures = {
        workspace_swipe = true;
      };

      # Window rules
      windowrulev2 = [
        "float,class:(pavucontrol)"
        "float,class:(qalculate-gtk)"
        "float,title:(Picture-in-Picture)"
      ];

      # Key bindings
      "$mod" = "SUPER";

      bind = [
        # Window focus (vim-style navigation)
        "${parseKey keybindings.focusLeft}, movefocus, l"
        "${parseKey keybindings.focusRight}, movefocus, r"
        "${parseKey keybindings.focusDown}, movefocus, d"
        "${parseKey keybindings.focusUp}, movefocus, u"

        # Window actions
        "${parseKey keybindings.windowClose}, killactive"
        "${parseKey keybindings.windowFullscreen}, fullscreen, 0"
        "${parseKey keybindings.windowFloat}, togglefloating"

        # App launchers
        "${parseKey keybindings.launchTerminal}, exec, alacritty"
        "${parseKey keybindings.launchBrowser}, exec, firefox"
        "${parseKey keybindings.launchFileManager}, exec, thunar"
        "${parseKey keybindings.launchVscode}, exec, code"
        "${parseKey keybindings.launchSystemMonitor}, exec, alacritty -e btop"
        "${parseKey keybindings.appRunner}, exec, rofi -show drun"

        # Workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"

        # Move windows to workspaces
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"

        # Screenshots (handled by hyprshot module)
        "${parseKey keybindings.screenshotArea}, exec, hyprshot -m region"
        "${parseKey keybindings.screenshotFull}, exec, hyprshot -m output"
        "${parseKey keybindings.screenshotWindow}, exec, hyprshot -m window"

        # System actions
        "${parseKey keybindings.lockSession}, exec, hyprlock"
        "${parseKey keybindings.powerMenu}, exec, rofi-power-menu"
      ];

      # Volume bindings (special keys)
      bindl = [
        "${parseKey keybindings.volumeUp}, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        "${parseKey keybindings.volumeDown}, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        "${parseKey keybindings.volumeMute}, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ];

      # Mouse bindings
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };

  # Install required packages
  home.packages = with pkgs; [
    # Hyprland ecosystem
    hyprpaper
    hyprlock
    hypridle
    hyprpicker
    hyprshot

    # Wayland utilities
    wl-clipboard # Clipboard manager
    wlr-randr # Display configuration
    slurp # Region selector
    grim # Screenshot utility (used by hyprshot)
    swappy # Screenshot editor

    # Additional utilities
    brightnessctl # Brightness control
    # Note: wpctl comes with pipewire (enabled at system level)
  ];

  # XDG portal configuration for screen sharing
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };
}
