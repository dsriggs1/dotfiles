{...}: {
  # Firewall
  networking.firewall.enable = true;
  # Open ports in the firewall.
  #networking.firewall.allowedTCPPorts = [8096 8920];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
