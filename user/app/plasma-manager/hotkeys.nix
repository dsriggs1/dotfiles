{keybindings, ...}: {
  programs.plasma = {
    enable = true;
    hotkeys.commands = {
      # Terminal
      launch-alacritty = {
        name = "Launch Alacritty";
        key = keybindings.launchTerminal;
        command = "alacritty";
      };

      # Browser
      launch-firefox = {
        name = "Launch Firefox";
        key = keybindings.launchBrowser;
        command = "firefox";
      };

      # File Manager
      launch-file-manager = {
        name = "Launch File Manager";
        key = keybindings.launchFileManager;
        command = "dolphin";
      };

      # Screenshots
      screenshot-area = {
        name = "Screenshot Area";
        key = keybindings.screenshotArea;
        command = "spectacle -r";
      };

      screenshot-full = {
        name = "Screenshot Full Screen";
        key = keybindings.screenshotFull;
        command = "spectacle -f";
      };

      screenshot-window = {
        name = "Screenshot Window";
        key = keybindings.screenshotWindow;
        command = "spectacle -a";
      };

      # System
      power-menu = {
        name = "Power Menu";
        key = keybindings.powerMenu;
        command = "qdbus org.kde.LogoutPrompt /LogoutPrompt promptAll";
      };

      launch-system-monitor = {
        name = "Launch System Monitor";
        key = keybindings.launchSystemMonitor;
        command = "plasma-systemmonitor";
      };

      # Application Launcher
      launch-runner = {
        name = "KRunner";
        key = keybindings.appRunner;
        command = "krunner";
      };

      # Clipboard (plasma-specific: requires klipper)
      clipboard-history = {
        name = "Clipboard History";
        key = "Meta+V";
        command = "qdbus org.kde.klipper /klipper showKlipperPopupMenu";
      };

      # Editor
      launch-vscode = {
        name = "Launch VSCode";
        key = keybindings.launchVscode;
        command = "code";
      };

      # Volume Controls
      volume-up = {
        name = "Volume Up";
        key = keybindings.volumeUp;
        command = "pactl set-sink-volume @DEFAULT_SINK@ +5%";
      };

      volume-down = {
        name = "Volume Down";
        key = keybindings.volumeDown;
        command = "pactl set-sink-volume @DEFAULT_SINK@ -5%";
      };

      volume-mute = {
        name = "Volume Mute";
        key = keybindings.volumeMute;
        command = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
      };
    };
  };
}
