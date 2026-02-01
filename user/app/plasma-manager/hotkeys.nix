{...}: {
  programs.plasma = {
    enable = true;
    hotkeys.commands = {
      # Terminal
      launch-alacritty = {
        name = "Launch Alacritty";
        key = "Meta+Return";
        command = "alacritty";
      };

      # Browser
      launch-firefox = {
        name = "Launch Firefox";
        key = "Meta+Shift+B";
        command = "firefox";
      };

      # File Manager
      launch-file-manager = {
        name = "Launch File Manager";
        key = "Meta+E";
        command = "dolphin";
      };

      # Screenshots
      screenshot-area = {
        name = "Screenshot Area";
        key = "Meta+Shift+S";
        command = "spectacle -r";
      };

      screenshot-full = {
        name = "Screenshot Full Screen";
        key = "Print";
        command = "spectacle -f";
      };

      screenshot-window = {
        name = "Screenshot Window";
        key = "Meta+Print";
        command = "spectacle -a";
      };

      # System
      power-menu = {
        name = "Power Menu";
        key = "Meta+Ctrl+Delete";
        command = "qdbus org.kde.LogoutPrompt /LogoutPrompt promptAll";
      };

      launch-system-monitor = {
        name = "Launch System Monitor";
        key = "Meta+Shift+Escape";
        command = "plasma-systemmonitor";
      };

      # Application Launcher
      launch-runner = {
        name = "KRunner";
        key = "Meta+Space";
        command = "krunner";
      };

      # Clipboard
      clipboard-history = {
        name = "Clipboard History";
        key = "Meta+V";
        command = "qdbus org.kde.klipper /klipper showKlipperPopupMenu";
      };

      # Editor
      launch-vscode = {
        name = "Launch VSCode";
        key = "Meta+Shift+C";
        command = "code";
      };

      # Volume Controls
      volume-up = {
        name = "Volume Up";
        key = "Meta+Up";
        command = "pactl set-sink-volume @DEFAULT_SINK@ +5%";
      };

      volume-down = {
        name = "Volume Down";
        key = "Meta+Down";
        command = "pactl set-sink-volume @DEFAULT_SINK@ -5%";
      };

      volume-mute = {
        name = "Volume Mute";
        key = "Meta+M";
        command = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
      };
    };
  };
}
