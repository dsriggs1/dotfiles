{...}: {
  programs.plasma = {
    enable = true;

    powerdevil = {
      # ── AC (plugged in) ───────────────────────────────────────────────────────
      AC = {
        # Lid behavior
        whenLaptopLidClosed = "doNothing";
        inhibitLidActionWhenExternalMonitorConnected = true;

        # Idle → suspend
        autoSuspend = {
          action = "nothing"; # "sleep" | "hibernate" | "shutDown" | "nothing"
          idleTimeout = null;
        };
        whenSleepingEnter = "standbyThenHibernate";

        # Display behavior
        dimDisplay = {
          enable = false;
          idleTimeout = null;
        };
        turnOffDisplay = {
          idleTimeout = "never";
          idleTimeoutWhenLocked = null;
        };

        displayBrightness = 70; # keep full brightness on AC
        powerProfile = "balanced"; # "performance" | "balanced" | "powerSaving"
      };

      # ── Battery (unplugged) ──────────────────────────────────────────────────
      battery = {
        # Lid behavior
        whenLaptopLidClosed = "sleep";
        inhibitLidActionWhenExternalMonitorConnected = true;

        # Idle → suspend
        autoSuspend = {
          action = "sleep";
          idleTimeout = 1200; # suspend after 20 min inactive
        };
        whenSleepingEnter = "standbyThenHibernate";

        # Display behavior
        dimDisplay = {
          enable = true;
          idleTimeout = 120; # dim after 2 min
        };
        turnOffDisplay = {
          idleTimeout = 300; # off after 5 min (unlocked)
          idleTimeoutWhenLocked = 60; # off after 1 min when locked
        };

        displayBrightness = 60; # cap brightness on battery
        powerProfile = "powerSaving";
      };

      # ── Low Battery (extra-aggressive) ───────────────────────────────────────
      lowBattery = {
        # Lid behavior follows normal battery rule
        whenLaptopLidClosed = "sleep";
        inhibitLidActionWhenExternalMonitorConnected = true;

        # Idle → hibernate quickly
        autoSuspend = {
          action = "hibernate";
          idleTimeout = 300; # hibernate after 5 min inactive
        };

        # Display behavior
        dimDisplay = {
          enable = true;
          idleTimeout = 60; # dim after 1 min
        };
        turnOffDisplay = {
          idleTimeout = 120; # off after 2 min (unlocked)
          idleTimeoutWhenLocked = "immediately"; # off immediately when locked
        };

        displayBrightness = 30;
      };

      # ── General + thresholds ─────────────────────────────────────────────────
      general = {
        pausePlayersOnSuspend = true;
      };

      batteryLevels = {
        lowLevel = 15;
        criticalLevel = 5;
        criticalAction = "hibernate";
      };
    };
  };
}
