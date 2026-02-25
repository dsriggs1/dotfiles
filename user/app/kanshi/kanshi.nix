{pkgs, ...}: {
  # Kanshi - Automatic display configuration for Wayland
  # This is the Wayland equivalent of autorandr

  services.kanshi = {
    enable = true;

    # System service that runs in the background
    systemdTarget = "graphical-session.target";

    settings = [
      # Profile: laptop only (mobile)
      {
        profile.name = "mobile";
        profile.outputs = [
          {
            criteria = "eDP-1";
            mode = "2256x1504@60";
            position = "0,0";
            scale = 1.0;
          }
        ];
      }

      # Profile: dual external monitors (docked, no laptop)
      {
        profile.name = "docked";
        profile.outputs = [
          {
            criteria = "DVI-I-1-1";
            mode = "1920x1080@60";
            position = "0,0";
            scale = 1.0;
          }
          {
            criteria = "DVI-I-2-2";
            mode = "1920x1080@60";
            position = "1920,0";
            scale = 1.0;
          }
        ];
      }

      # Profile: triple monitor (laptop + both externals)
      {
        profile.name = "triple";
        profile.outputs = [
          {
            criteria = "DVI-I-1-1";
            mode = "1920x1080@60";
            position = "0,0";
            scale = 1.0;
          }
          {
            criteria = "DVI-I-2-2";
            mode = "1920x1080@60";
            position = "1920,0";
            scale = 1.0;
          }
          {
            criteria = "eDP-1";
            mode = "2256x1504@60";
            position = "3840,0";
            scale = 1.0;
          }
        ];
      }

      # Profile: single external + laptop
      {
        profile.name = "external-left";
        profile.outputs = [
          {
            criteria = "DVI-I-1-1";
            mode = "1920x1080@60";
            position = "0,0";
            scale = 1.0;
          }
          {
            criteria = "eDP-1";
            mode = "2256x1504@60";
            position = "1920,0";
            scale = 1.0;
          }
        ];
      }

      {
        profile.name = "external-right";
        profile.outputs = [
          {
            criteria = "DVI-I-2-2";
            mode = "1920x1080@60";
            position = "0,0";
            scale = 1.0;
          }
          {
            criteria = "eDP-1";
            mode = "2256x1504@60";
            position = "1920,0";
            scale = 1.0;
          }
        ];
      }
    ];
  };
}
