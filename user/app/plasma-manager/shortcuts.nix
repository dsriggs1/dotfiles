{keybindings, ...}: {
  programs.plasma = {
    enable = true;
    shortcuts = {
      ksmserver = {
        "Lock Session" = [
          "Screensaver"
          keybindings.lockSession
        ];
      };

      plasmashell = {
        "manage activities" = "";
        "activate task manager entry 1" = "";
        "activate task manager entry 2" = "";
        "activate task manager entry 3" = "";
        "activate task manager entry 4" = "";
        "activate task manager entry 5" = "";
      };

      kwin = {
        # Plasma-specific (not in shared keybindings)
        "Expose" = "Meta+,";
        "KrohnkiteSetMaster" = "";

        # Shared: navigation
        "Switch Window Left" = keybindings.focusLeft;
        "Switch Window Right" = keybindings.focusRight;
        "Switch Window Down" = keybindings.focusDown;
        "Switch Window Up" = keybindings.focusUp;

        # Shared: window actions
        "Window Close" = keybindings.windowClose;
        "Window Fullscreen" = keybindings.windowFullscreen;
        "KrohnkiteToggleFloat" = keybindings.windowFloat;

        # Workspaces (pattern matches qtile's generated loop)
        "Switch to Desktop 1" = "Meta+1";
        "Switch to Desktop 2" = "Meta+2";
        "Switch to Desktop 3" = "Meta+3";
        "Switch to Desktop 4" = "Meta+4";
        "Switch to Desktop 5" = "Meta+5";
        "Move Window to Desktop 1" = "Meta+Shift+1";
        "Move Window to Desktop 2" = "Meta+Shift+2";
        "Move Window to Desktop 3" = "Meta+Shift+3";
        "Move Window to Desktop 4" = "Meta+Shift+4";
        "Move Window to Desktop 5" = "Meta+Shift+5";
      };
    };
  };
}
