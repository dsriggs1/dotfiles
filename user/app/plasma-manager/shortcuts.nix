{...}: {
  programs.plasma = {
    enable = true;
    shortcuts = {
      ksmserver = {
        "Lock Session" = [
          "Screensaver"
          "Meta+Ctrl+Alt+L"
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
        "Expose" = "Meta+,";
        "Switch Window Down" = "Meta+J";
        "Switch Window Left" = "Meta+H";
        "Switch Window Right" = "Meta+L";
        "Switch Window Up" = "Meta+K";
        "KrohnkiteSetMaster" = "";
        "Switch to Desktop 1" = "Meta+1";
        "Switch to Desktop 2" = "Meta+2";
        "Switch to Desktop 3" = "Meta+3";
        "Switch to Desktop 4" = "Meta+4";
        "Switch to Desktop 5" = "Meta+5";
        "Window Close" = "Meta+Q";
        "Window Fullscreen" = "Meta+F";
      };
    };
  };
}
