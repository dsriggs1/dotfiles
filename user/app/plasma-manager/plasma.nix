{...}: {
  programs.plasma = {
    enable = true;

    #
    # Some high-level settings:
    #
    workspace = {
      clickItemTo = "select";
      lookAndFeel = "org.kde.breezedark.desktop";
      # cursor.theme = "Bibata-Modern-Ice";
      #     iconTheme = "Papirus-Dark";
      # wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Patak/contents/images/1080x1920.png";
    };

    hotkeys.commands."launch-alacritty" = {
      name = "Launch Alacritty";
      key = "Meta+Return";
      command = "alacritty";
    };

    panels = [
      # Top panel (cleaned up)
      {
        floating = true;
        height = 34;
        lengthMode = "fill";
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
                use24hFormat = 2;
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

    #
    # Some mid-level settings:
    #
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

    kwin = {
      effects = {
        blur = {
          enable = true;
          strength = 5;
          noiseStrength = 8;
        };
        cube.enable = false;
        desktopSwitching.animation = "off";
        dimAdminMode.enable = false;
        dimInactive.enable = false;
        fallApart.enable = false;
        fps.enable = false;
        minimization.animation = "off";
        shakeCursor.enable = false;
        slideBack.enable = false;
        snapHelper.enable = false;
        translucency.enable = true;
        windowOpenClose.animation = "off";
        wobblyWindows.enable = false;
      };
      virtualDesktops = {
        number = 5;
        rows = 1;
      };
    };

    window-rules = [
      {
        description = "Alacritty active opacity 70%";

        match = {
          window-class = {
            value = "alacritty";
            type = "substring";
            match-whole = true;
          };
        };

        apply = {
          opacityactive = {
            value = 70;
            apply = "force"; # or "initially" if you only want it set on startup
          };
        };
      }

      {
        description = "Rstudio active opacity 70%";

        match = {
          window-class = {
            value = "rstudio";
            type = "substring";
            match-whole = true;
          };
        };

        apply = {
          opacityactive = {
            value = 70;
            apply = "force"; # or "initially" if you only want it set on startup
          };
        };
      }
      {
        description = "Dolphin active opacity 70%";
        match = {
          window-class = {
            value = "dolphin";
            type = "substring";
            match-whole = true;
          };
        };
        apply = {
          opacityactive = {
            value = 70;
            apply = "force";
          };
        };
      }
      {
        description = "Assign Firefox to Desktop 2";
        match = {
          window-class = {
            # match = {
            value = "firefox";
            type = "substring";
            match-whole = true;
          };
        };
        apply = {
          desktops = "Desktop_2";
          desktopsrule = "3";
        }; # apply = "initially";
      } # };
    ];

    #
    # Some low-level settings:
    #
    configFile = {
      "baloofilerc"."Basic Settings"."Indexing-Enabled" = false;
      "kwinrc"."org.kde.kdecoration2"."ButtonsOnLeft" = "SF";
      "kwinrc"."Desktops"."Number" = {
        value = 5;
        # Forces kde to not change this value (even through the settings app).
        immutable = true;
      };
      kwinrc = {
        Effect-overview.BorderActivate = 9;
        Plugins = {
          krohnkiteEnabled = true;
        };
        "Round-Corners" = {
          ActiveOutlineAlpha = 255;
          ActiveOutlineUseCustom = false;
          ActiveOutlineUsePalette = true;
          ActiveSecondOutlineUseCustom = false;
          ActiveSecondOutlineUsePalette = true;
          DisableOutlineTile = false;
          DisableRoundTile = false;
          InactiveCornerRadius = 8;
          InactiveOutlineAlpha = 0;
          InactiveOutlineUseCustom = false;
          InactiveOutlineUsePalette = true;
          InactiveSecondOutlineAlpha = 0;
          InactiveSecondOutlineThickness = 0;
          OutlineThickness = 1;
          SecondOutlineThickness = 0;
          Size = 8;
        };
        "Script-krohnkite" = {
          screenGapBetween = 3;
          screenGapBottom = 3;
          screenGapLeft = 3;
          screenGapRight = 3;
          screenGapTop = 3;
        };
      };
    };
  };
}
