{pkgs, ...}: {
  # Autorandr - Automatic display configuration for X11
  # Declarative monitor profiles that auto-detect and switch based on connected displays

  programs.autorandr = {
    enable = true;

    # Hooks that run after profile switches
    hooks = {
      postswitch = {
        # Notify user of profile change
        "notify-user" = ''
          ${pkgs.libnotify}/bin/notify-send -u low "Display" "Switched to profile $AUTORANDR_CURRENT_PROFILE"
        '';

        # Restart compositor if running
        "restart-compositor" = ''
          if ${pkgs.procps}/bin/pgrep -x picom > /dev/null; then
            ${pkgs.procps}/bin/pkill picom
            ${pkgs.picom}/bin/picom -b &
          fi
        '';

        # Fix wallpaper after display change
        "fix-wallpaper" = ''
          if [ -f ~/.config/stylix/wallpaper ]; then
            ${pkgs.feh}/bin/feh --bg-scale ~/.config/stylix/wallpaper 2>/dev/null || true
          fi
        '';

        # Reload qtile to detect new screens
        "reload-qtile" = ''
          if ${pkgs.procps}/bin/pgrep -x qtile > /dev/null; then
            ${pkgs.python3Packages.qtile}/bin/qtile cmd-obj -o cmd -f reload_config || true
          fi
        '';
      };
    };

    # Monitor profiles
    profiles = {
      # Profile: Laptop only (mobile)
      "mobile" = {
        fingerprint = {
          eDP-1 = "00ffffffffffff0009e5ca0b000000002f200104a51c137803de50a3544c99260f505400000001010101010101010101010101010101115cd01881e02d50302036001dbe1000001aa749d01881e02d50302036001dbe1000001a000000fe00424f452043510a202020202020000000fe004e4531333546424d2d4e34310a0073";
        };
        config = {
          eDP-1 = {
            enable = true;
            primary = true;
            mode = "2256x1504";
            position = "0x0";
            rate = "60.00";
          };
          DVI-I-1-1.enable = false;
          DVI-I-2-2.enable = false;
        };
      };

      # Profile: Triple monitors (docked - all 3 displays)
      "docked" = {
        fingerprint = {
          eDP-1 = "00ffffffffffff0009e5ca0b000000002f200104a51c137803de50a3544c99260f505400000001010101010101010101010101010101115cd01881e02d50302036001dbe1000001aa749d01881e02d50302036001dbe1000001a000000fe00424f452043510a202020202020000000fe004e4531333546424d2d4e34310a0073";
          DVI-I-1-1 = "00ffffffffffff0010ac18d1565931300e200103803c2278ea7865a45550a0270e5054a54b00714f8180a9c0d1c00101010101010101023a801871382d40582c4500544f2100001e000000ff00374b4230304e330a2020202020000000fc0044454c4c205345323732324858000000fd00304b1e5312000a20202020202001a2020320b14c9005040302071601141f121365030c001000681a00000101304be62a4480a07038274030203500544f2100001a011d8018711c1620582c2500544f2100009e011d007251d01e206e285500544f2100001e8c0ad08a20e02d10103e9600544f21000018000000000000000000000000000000000000000000000034";
          DVI-I-2-2 = "00ffffffffffff0010accaa1513958300d20010380351e78ee96d5a655519d260f5054a54b00714f8180a9c0d1c00101010101010101023a801871382d40582c45000f282100001e000000ff004443304a5742330a2020202020000000fc0044454c4c205345323432324858000000fd00304b1f5412000a20202020202001dd020323b14b900504030201111213141f8300000065030c001000681a00000101304b002a4480a070382740302035000f282100001a011d8018711c1620582c250020c23100009e011d007251d01e206e2855000f282100001e8c0ad08a20e02d10103e96000f2821000018000000000000000000000000000000000000000096";
        };
        config = {
          DVI-I-1-1 = {
            enable = true;
            mode = "1920x1080";
            position = "0x0";
            rate = "60.00";
          };
          DVI-I-2-2 = {
            enable = true;
            mode = "1920x1080";
            position = "1920x0";
            rate = "60.00";
          };
          eDP-1 = {
            enable = true;
            primary = true;
            mode = "2256x1504";
            position = "3840x0";
            rate = "60.00";
          };
        };
      };

      # Profile: Laptop + Left external (DVI-I-1-1)
      "external-left" = {
        fingerprint = {
          eDP-1 = "00ffffffffffff0009e5ca0b000000002f200104a51c137803de50a3544c99260f505400000001010101010101010101010101010101115cd01881e02d50302036001dbe1000001aa749d01881e02d50302036001dbe1000001a000000fe00424f452043510a202020202020000000fe004e4531333546424d2d4e34310a0073";
          DVI-I-1-1 = "00ffffffffffff0010ac18d1565931300e200103803c2278ea7865a45550a0270e5054a54b00714f8180a9c0d1c00101010101010101023a801871382d40582c4500544f2100001e000000ff00374b4230304e330a2020202020000000fc0044454c4c205345323732324858000000fd00304b1e5312000a20202020202001a2020320b14c9005040302071601141f121365030c001000681a00000101304be62a4480a07038274030203500544f2100001a011d8018711c1620582c2500544f2100009e011d007251d01e206e285500544f2100001e8c0ad08a20e02d10103e9600544f21000018000000000000000000000000000000000000000000000034";
        };
        config = {
          DVI-I-1-1 = {
            enable = true;
            mode = "1920x1080";
            position = "0x0";
            rate = "60.00";
          };
          eDP-1 = {
            enable = true;
            primary = true;
            mode = "2256x1504";
            position = "1920x0";
            rate = "60.00";
          };
          DVI-I-2-2.enable = false;
        };
      };

      # Profile: Laptop + Right external (DVI-I-2-2)
      "external-right" = {
        fingerprint = {
          eDP-1 = "00ffffffffffff0009e5ca0b000000002f200104a51c137803de50a3544c99260f505400000001010101010101010101010101010101115cd01881e02d50302036001dbe1000001aa749d01881e02d50302036001dbe1000001a000000fe00424f452043510a202020202020000000fe004e4531333546424d2d4e34310a0073";
          DVI-I-2-2 = "00ffffffffffff0010accaa1513958300d20010380351e78ee96d5a655519d260f5054a54b00714f8180a9c0d1c00101010101010101023a801871382d40582c45000f282100001e000000ff004443304a5742330a2020202020000000fc0044454c4c205345323432324858000000fd00304b1f5412000a20202020202001dd020323b14b900504030201111213141f8300000065030c001000681a00000101304b002a4480a070382740302035000f282100001a011d8018711c1620582c250020c23100009e011d007251d01e206e2855000f282100001e8c0ad08a20e02d10103e96000f2821000018000000000000000000000000000000000000000096";
        };
        config = {
          DVI-I-2-2 = {
            enable = true;
            mode = "1920x1080";
            position = "0x0";
            rate = "60.00";
          };
          eDP-1 = {
            enable = true;
            primary = true;
            mode = "2256x1504";
            position = "1920x0";
            rate = "60.00";
          };
          DVI-I-1-1.enable = false;
        };
      };
    };
  };
}
