{...}: {
  services.expressvpn = {
    enable = true;
  };

  # Fix: Ensure expressvpn starts after impermanence bind mount
  # and stops cleanly before unmounting during shutdown
  systemd.services.expressvpn = {
    # Startup ordering: wait for mount to be ready
    requires = ["var-lib-expressvpn.mount"];
    after = ["var-lib-expressvpn.mount" "network-online.target"];

    # Shutdown ordering: stop before filesystems are unmounted
    # This ensures activation data is properly flushed to disk
    before = ["umount.target"];

    # Give service time to clean up and flush data during shutdown
    serviceConfig = {
      TimeoutStopSec = 10;
    };
  };
}
