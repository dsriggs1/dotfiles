{pkgs, ...}: {
  services.hypridle = {
    enable = true;

    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock"; # Avoid starting multiple instances
        before_sleep_cmd = "loginctl lock-session"; # Lock before suspend
        after_sleep_cmd = "hyprctl dispatch dpms on"; # Turn on display after resume
        ignore_dbus_inhibit = false;
      };

      listener = [
        # Dim screen after 5 minutes
        {
          timeout = 300;
          on-timeout = "brightnessctl -s set 10"; # Save current brightness, then dim
          on-resume = "brightnessctl -r"; # Restore brightness
        }

        # Turn off screen after 10 minutes
        {
          timeout = 600;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }

        # Lock screen after 15 minutes
        {
          timeout = 900;
          on-timeout = "loginctl lock-session";
        }

        # Suspend after 30 minutes
        {
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
