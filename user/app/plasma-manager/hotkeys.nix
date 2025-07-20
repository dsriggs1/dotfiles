{...}: {
  programs.plasma = {
    enable = true;
    hotkeys.commands = {
      launch-alacritty = {
        name = "Launch Alacritty";
        key = "Meta+Return";
        command = "alacritty";
      };

      launch-firefox = {
        name = "Launch Firefox";
        key = "Meta+Shift+B";
        command = "firefox";
      };
    };
  };
}
