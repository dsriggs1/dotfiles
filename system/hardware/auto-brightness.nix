{
  pkgs,
  userSettings,
  ...
}: let
  brightness-manager = pkgs.writeShellScript "brightness-manager" ''
    #!/usr/bin/env bash

    # Get AC adapter status (check ACAD first, then fallback to AC/ADP patterns)
    ac_online=$(cat /sys/class/power_supply/ACAD/online 2>/dev/null || cat /sys/class/power_supply/AC*/online 2>/dev/null || cat /sys/class/power_supply/ADP*/online 2>/dev/null || echo "1")

    # Get battery percentage
    battery_capacity=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -n1)

    # Default to 100 if we can't read battery (desktop scenario)
    battery_capacity=''${battery_capacity:-100}

    # Determine target brightness (KDE PowerDevil uses 0-10000 scale)
    if [ "$ac_online" = "1" ]; then
      # Plugged in: 100% brightness
      target_brightness=10000
    else
      # Unplugged: step down based on battery level
      if [ "$battery_capacity" -ge 50 ]; then
        target_brightness=5000  # 50%
      elif [ "$battery_capacity" -ge 25 ]; then
        target_brightness=4000  # 40%
      elif [ "$battery_capacity" -ge 10 ]; then
        target_brightness=3000  # 30%
      else
        target_brightness=2000  # 20%
      fi
    fi

    # Set brightness using KDE PowerDevil DBus interface
    # This integrates with KDE's power management instead of fighting it
    # Since we're running as a user service, we have natural access to the session DBus
    ${pkgs.libsForQt5.qttools}/bin/qdbus org.kde.Solid.PowerManagement \
      /org/kde/Solid/PowerManagement/Actions/BrightnessControl \
      setBrightness "$target_brightness" 2>/tmp/brightness-dbus-error.log

    # Fallback to brightnessctl if KDE PowerDevil is not available
    if [ $? -ne 0 ]; then
      # Convert to percentage for brightnessctl
      percentage=$((target_brightness / 100))
      ${pkgs.brightnessctl}/bin/brightnessctl set ''${percentage}%
    fi

    # Log the change (for debugging)
    echo "$(date): AC=$ac_online, Battery=$battery_capacity%, Target=$target_brightness, Result=$?" >> /tmp/brightness-manager.log
  '';
in {
  # Install brightnessctl
  environment.systemPackages = with pkgs; [
    brightnessctl
  ];

  # Allow users in video group to control brightness without sudo
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
  '';

  # Systemd user service that runs in the user's session
  systemd.user.services.auto-brightness = {
    description = "Automatic brightness adjustment based on battery status";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = brightness-manager;
    };
    # Increase rate limit to prevent boot errors when udev triggers multiple times
    startLimitIntervalSec = 60;
    startLimitBurst = 10;
  };

  # User timer to run every 2 minutes
  systemd.user.timers.auto-brightness = {
    description = "Timer for automatic brightness adjustment";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "30s"; # Start 30 seconds after boot
      OnUnitActiveSec = "2m"; # Run every 2 minutes
      AccuracySec = "30s"; # Allow 30s jitter for power efficiency
    };
  };
}
