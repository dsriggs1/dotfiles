{
  pkgs,
  config,
  ...
}: {
  # hyprshot is a screenshot utility for Hyprland
  # Keybindings are configured in hyprland.nix using shared keybindings:
  # - screenshotArea: Meta+Shift+S (region selection)
  # - screenshotFull: Print (full screen)
  # - screenshotWindow: Meta+Print (current window)

  # Screenshots are saved to Pictures/Screenshots
  home.file.".config/hypr/hyprshot.conf".text = ''
    # Screenshot directory
    SCREENSHOT_DIR="${config.xdg.userDirs.pictures}/Screenshots"
  '';

  # Ensure screenshot directory exists
  home.activation.createScreenshotDir = config.lib.dag.entryAfter ["writeBoundary"] ''
    mkdir -p "${config.xdg.userDirs.pictures}/Screenshots"
  '';

  # Wrapper scripts for screenshots with notifications
  home.packages = with pkgs; [
    (writeShellScriptBin "hyprshot-region" ''
      #!/usr/bin/env bash
      SCREENSHOT_DIR="${config.xdg.userDirs.pictures}/Screenshots"
      mkdir -p "$SCREENSHOT_DIR"
      FILENAME="$SCREENSHOT_DIR/screenshot-$(date +%Y%m%d-%H%M%S).png"

      ${pkgs.hyprshot}/bin/hyprshot -m region -o "$SCREENSHOT_DIR" && \
        ${pkgs.libnotify}/bin/notify-send "Screenshot" "Saved region to Screenshots/" -i camera-photo
    '')

    (writeShellScriptBin "hyprshot-output" ''
      #!/usr/bin/env bash
      SCREENSHOT_DIR="${config.xdg.userDirs.pictures}/Screenshots"
      mkdir -p "$SCREENSHOT_DIR"
      FILENAME="$SCREENSHOT_DIR/screenshot-$(date +%Y%m%d-%H%M%S).png"

      ${pkgs.hyprshot}/bin/hyprshot -m output -o "$SCREENSHOT_DIR" && \
        ${pkgs.libnotify}/bin/notify-send "Screenshot" "Saved full screen to Screenshots/" -i camera-photo
    '')

    (writeShellScriptBin "hyprshot-window" ''
      #!/usr/bin/env bash
      SCREENSHOT_DIR="${config.xdg.userDirs.pictures}/Screenshots"
      mkdir -p "$SCREENSHOT_DIR"
      FILENAME="$SCREENSHOT_DIR/screenshot-$(date +%Y%m%d-%H%M%S).png"

      ${pkgs.hyprshot}/bin/hyprshot -m window -o "$SCREENSHOT_DIR" && \
        ${pkgs.libnotify}/bin/notify-send "Screenshot" "Saved window to Screenshots/" -i camera-photo
    '')
  ];
}
