{
  config,
  lib,
  ...
}: {
  services.hyprpaper = {
    enable = true;

    settings = {
      # Use stylix wallpaper
      preload = ["${config.stylix.image}"];

      # Apply to all monitors
      wallpaper = [
        ",${config.stylix.image}"
      ];

      # Enable IPC for runtime control
      ipc = "on";

      # Splash rendering (disable for better performance)
      splash = false;

      # Whether to fully unload preloaded images after use
      splash_offset = 2.0;
    };
  };
}
