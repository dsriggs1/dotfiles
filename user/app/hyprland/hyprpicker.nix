{pkgs, ...}: {
  # hyprpicker is a simple color picker utility for Wayland
  # Usage: Run 'hyprpicker' or 'hyprpicker -a' (autocopy to clipboard)
  # The package is installed in the main hyprland.nix

  # Add a convenient keybinding in hyprland config
  wayland.windowManager.hyprland.settings.bind = [
    "SUPER SHIFT, C, exec, hyprpicker -a -n" # Pick color and copy to clipboard, no preview
  ];

  # Optional: Create a wrapper script for enhanced functionality
  home.packages = with pkgs; [
    (writeShellScriptBin "color-picker" ''
      #!/usr/bin/env bash
      # Enhanced color picker with notification
      color=$(${pkgs.hyprpicker}/bin/hyprpicker -a -n -r)
      if [ -n "$color" ]; then
        ${pkgs.libnotify}/bin/notify-send "Color Picked" "$color" -i color-picker
      fi
    '')
  ];
}
