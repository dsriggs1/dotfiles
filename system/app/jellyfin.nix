{...}: {
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  services.lidarr = {
    enable = true;
    openFirewall = true;
  };
  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };
  services.radarr = {
    enable = true;
    openFirewall = true;
  };
  services.readarr = {
    enable = true;
    openFirewall = true;
  };
  #  services.sonarr = {
  #   enable = true;
  #  openFirewall = true;
  #};
  #  services.bazarr = {
  #   enable = true;
  #  openFirewall = true;
  # };
}
