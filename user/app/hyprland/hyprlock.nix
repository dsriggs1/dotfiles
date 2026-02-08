{
  pkgs,
  config,
  lib,
  ...
}: {
  # Disable stylix for hyprlock to use custom config
  stylix.targets.hyprlock.enable = false;

  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        disable_loading_bar = false;
        hide_cursor = true;
        grace = 5;
        no_fade_in = false;
      };

      # Background
      background = [
        {
          monitor = "";
          path = "screenshot"; # Uses screenshot as background
          blur_passes = 3;
          blur_size = 8;
          noise = 0.0117;
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
        }
      ];

      # Input field
      input-field = [
        {
          monitor = "";
          size = "300, 50";
          outline_thickness = 2;
          dots_size = 0.2;
          dots_spacing = 0.2;
          dots_center = true;
          outer_color = "rgba(${config.lib.stylix.colors.base0E}FF)"; # Purple
          inner_color = "rgba(${config.lib.stylix.colors.base00}BB)"; # Background
          font_color = "rgb(${config.lib.stylix.colors.base05})"; # Foreground
          fade_on_empty = false;
          placeholder_text = ''<span foreground="##${config.lib.stylix.colors.base04}">Enter Password...</span>'';
          hide_input = false;
          position = "0, -120";
          halign = "center";
          valign = "center";
        }
      ];

      # Time
      label = [
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$(date +'%H:%M')"'';
          color = "rgb(${config.lib.stylix.colors.base05})";
          font_size = 120;
          font_family = config.stylix.fonts.monospace.name;
          position = "0, 300";
          halign = "center";
          valign = "center";
        }

        # Date
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$(date +'%A, %B %d')"'';
          color = "rgb(${config.lib.stylix.colors.base04})";
          font_size = 24;
          font_family = config.stylix.fonts.sansSerif.name;
          position = "0, 200";
          halign = "center";
          valign = "center";
        }

        # User
        {
          monitor = "";
          text = "    $USER";
          color = "rgb(${config.lib.stylix.colors.base05})";
          font_size = 18;
          font_family = config.stylix.fonts.sansSerif.name;
          position = "0, -60";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
