{...}: {
  services.power-profiles-daemon.enable = false;

  # Enable Framework laptop charge control via cros_charge_control module
  boot.extraModprobeConfig = ''
    options cros_charge_control probe_with_fwk_charge_control=Y
  '';

  # Framework laptop battery charge limit (helps save long term battery health)
  # Sets the maximum charge threshold to 80%
  systemd.services.framework-battery-charge-limit = {
    description = "Set Framework battery charge limit to 80%";
    wantedBy = ["multi-user.target"];
    after = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      Restart = "on-failure";
      ExecStart = "/bin/sh -c 'echo 80 > /sys/class/power_supply/BAT1/charge_control_end_threshold'";
    };
  };

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 10;
      CPU_MAX_PERF_ON_BAT = 50;
    };
  };
}
