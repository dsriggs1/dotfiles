{
  pkgs,
  config,
  lib,
  ...
}: {
  programs.waybar = {
    enable = true;
    systemd.enable = false;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 35;
        spacing = 4;

        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];

        modules-center = [
          "clock"
        ];

        modules-right = [
          "idle_inhibitor"
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "temperature"
          "battery"
          "tray"
        ];

        # Workspaces
        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          format-icons = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            urgent = "";
            active = "";
            default = "";
          };
          persistent-workspaces = {
            "*" = 5; # 5 workspaces on all monitors
          };
        };

        # Active window title
        "hyprland/window" = {
          format = "{}";
          separate-outputs = true;
          max-length = 50;
        };

        # Clock
        clock = {
          interval = 1;
          format = "{:%H:%M:%S}";
          format-alt = "{:%Y-%m-%d %H:%M:%S}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#${config.lib.stylix.colors.base0D}'><b>{}</b></span>";
              days = "<span color='#${config.lib.stylix.colors.base05}'><b>{}</b></span>";
              weeks = "<span color='#${config.lib.stylix.colors.base0C}'><b>W{}</b></span>";
              weekdays = "<span color='#${config.lib.stylix.colors.base0A}'><b>{}</b></span>";
              today = "<span color='#${config.lib.stylix.colors.base08}'><b><u>{}</u></b></span>";
            };
          };
        };

        # Idle inhibitor
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
          tooltip-format-activated = "Idle inhibitor active";
          tooltip-format-deactivated = "Idle inhibitor inactive";
        };

        # Audio
        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = " Muted";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click = "pavucontrol";
        };

        # Network
        network = {
          format-wifi = " {signalStrength}%";
          format-ethernet = " {ipaddr}";
          format-disconnected = "⚠ Disconnected";
          tooltip-format = "{ifname} via {gwaddr}";
          tooltip-format-wifi = "{essid} ({signalStrength}%) ";
          tooltip-format-ethernet = "{ifname} ";
          tooltip-format-disconnected = "Disconnected";
          on-click = "nm-connection-editor";
        };

        # CPU
        cpu = {
          interval = 10;
          format = " {usage}%";
          tooltip = true;
        };

        # Memory
        memory = {
          interval = 30;
          format = " {percentage}%";
          tooltip-format = "RAM: {used:0.1f}G / {total:0.1f}G\nSwap: {swapUsed:0.1f}G / {swapTotal:0.1f}G";
        };

        # Temperature
        temperature = {
          thermal-zone = 2;
          hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
          critical-threshold = 80;
          format = "{icon} {temperatureC}°C";
          format-icons = ["" "" "" "" ""];
          tooltip = true;
        };

        # Battery
        battery = {
          interval = 60;
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{icon} {time}";
          format-icons = ["" "" "" "" ""];
          tooltip-format = "{timeTo}, {capacity}%";
        };

        # System tray
        tray = {
          icon-size = 18;
          spacing = 10;
        };
      };
    };

    # Custom CSS styling using stylix colors
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "${config.stylix.fonts.monospace.name}";
        font-size: ${toString config.stylix.fonts.sizes.applications}px;
        min-height: 0;
      }

      window#waybar {
        background-color: rgba(${config.lib.stylix.colors.base00-rgb-r}, ${config.lib.stylix.colors.base00-rgb-g}, ${config.lib.stylix.colors.base00-rgb-b}, 0.9);
        color: #${config.lib.stylix.colors.base05};
        transition-property: background-color;
        transition-duration: 0.5s;
      }

      #workspaces button {
        padding: 0 8px;
        color: #${config.lib.stylix.colors.base05};
        background-color: transparent;
        border-bottom: 3px solid transparent;
      }

      #workspaces button:hover {
        background-color: rgba(${config.lib.stylix.colors.base03-rgb-r}, ${config.lib.stylix.colors.base03-rgb-g}, ${config.lib.stylix.colors.base03-rgb-b}, 0.5);
      }

      #workspaces button.active {
        color: #${config.lib.stylix.colors.base0D};
        border-bottom: 3px solid #${config.lib.stylix.colors.base0D};
      }

      #workspaces button.urgent {
        color: #${config.lib.stylix.colors.base08};
        border-bottom: 3px solid #${config.lib.stylix.colors.base08};
      }

      #window {
        margin: 0 10px;
        color: #${config.lib.stylix.colors.base04};
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #temperature,
      #network,
      #pulseaudio,
      #idle_inhibitor,
      #tray {
        padding: 0 10px;
        margin: 0 2px;
      }

      #clock {
        color: #${config.lib.stylix.colors.base0D};
        font-weight: bold;
      }

      #battery {
        color: #${config.lib.stylix.colors.base0B};
      }

      #battery.charging {
        color: #${config.lib.stylix.colors.base0A};
      }

      #battery.warning:not(.charging) {
        color: #${config.lib.stylix.colors.base09};
      }

      #battery.critical:not(.charging) {
        color: #${config.lib.stylix.colors.base08};
        animation: blink 1s linear infinite;
      }

      @keyframes blink {
        to {
          background-color: #${config.lib.stylix.colors.base08};
          color: #${config.lib.stylix.colors.base00};
        }
      }

      #cpu {
        color: #${config.lib.stylix.colors.base0E};
      }

      #memory {
        color: #${config.lib.stylix.colors.base0C};
      }

      #temperature {
        color: #${config.lib.stylix.colors.base09};
      }

      #temperature.critical {
        color: #${config.lib.stylix.colors.base08};
        animation: blink 1s linear infinite;
      }

      #network {
        color: #${config.lib.stylix.colors.base0A};
      }

      #network.disconnected {
        color: #${config.lib.stylix.colors.base08};
      }

      #pulseaudio {
        color: #${config.lib.stylix.colors.base0B};
      }

      #pulseaudio.muted {
        color: #${config.lib.stylix.colors.base03};
      }

      #idle_inhibitor {
        color: #${config.lib.stylix.colors.base04};
      }

      #idle_inhibitor.activated {
        color: #${config.lib.stylix.colors.base0F};
      }

      #tray {
        background-color: transparent;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        color: #${config.lib.stylix.colors.base08};
      }
    '';
  };

  # Install waybar package (already handled by programs.waybar.enable, but ensure dependencies)
  home.packages = with pkgs; [
    waybar
  ];
}
