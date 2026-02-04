{...}: {
  programs.plasma = {
    enable = true;
    panels = [
      # Top panel (cleaned up)
      {
        floating = true;
        height = 34;
        #   lengthMode = "fill";
        location = "top";
        opacity = "translucent";
        widgets = [
          {
            name = "org.dhruv8sh.kara";
            config = {
              general = {
                animationDuration = 0;
                spacing = 3;
                type = 1;
              };
              type1 = {
                fixedLen = 3;
                labelSource = 0;
              };
            };
          }
          "org.kde.plasma.panelspacer"
          {
            name = "org.kde.plasma.digitalclock";
            config = {
              Appearance = {
                dateDisplayFormat = "BesideTime";
                dateFormat = "custom";
                use24hFormat = 0;
              };
            };
          }
          "org.kde.plasma.panelspacer"
          {
            systemTray = {
              items = {
                showAll = false;
                shown = [
                  "org.kde.plasma.clipboard"
                  "org.kde.plasma.volume"
                  "org.kde.plasma.battery"
                  "org.kde.plasma.bluetooth"
                  "org.kde.plasma.networkmanagement"
                  "org.kde.plasma.notifications"
                ];
                hidden = [
                  "org.kde.plasma.brightness"
                  "org.kde.plasma.devicenotifier"
                  "plasmashell_microphone"
                ];
                configs = {
                  "org.kde.plasma.notifications".config = {
                    Shortcuts = {
                      global = "Meta+V";
                    };
                  };
                  "org.kde.plasma.clipboard".config = {
                    Shortcuts = {
                      global = "Alt+Shift+V";
                    };
                  };
                };
              };
            };
          }
        ];
      }

      # Bottom dock
      {
        floating = true;
        height = 34;
        location = "bottom";
        lengthMode = "custom"; # or omit this line entirely
        alignment = "center";
        minLength = 200;
        maxLength = 200;
        hiding = "autohide";
        opacity = "translucent";
        widgets = [
          "org.kde.plasma.panelspacer"
          "org.kde.plasma.kickoff"
          {
            iconTasks = {
              launchers = [
                "applications:org.kde.dolphin.desktop"
                "applications:firefox.desktop"
                "applications:code.desktop"
              ];
            };
          }
          "org.kde.plasma.panelspacer"
        ];
      }
    ];
  };
}
