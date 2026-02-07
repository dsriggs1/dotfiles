{...}: {
  ########################################
  # Shared folders & permissions
  ########################################
  # A shared "media" group so all services can read/write the same folders.
  users.groups.media = {};

  # Add your user so you can manage files too.
  users.users.sean.extraGroups = ["media"];

  # Add the service users to the media group (these users are created by the modules).
  users.groups.media.members = [
    "jellyfin"
    "prowlarr"
    "radarr"
    "sonarr"
    "qbittorrent"
    "jellyseerr"
    "bazarr"
  ];

  # Create the directory structure at boot with sane perms.
  # Owner: sean, Group: media, Mode: 0775 (group-writable)
  systemd.tmpfiles.rules = [
    "d /srv 0755 root root - -"
    "d /srv/media 0775 sean media - -"
    "d /srv/media/movies 0775 sean media - -"
    "d /srv/media/shows 0775 sean media - -"
    "d /srv/media/fights 0775 sean media - -"
    "d /srv/downloads 0775 sean media - -"
    "d /srv/downloads/incomplete 0775 sean media - -"
    "d /srv/downloads/completed 0775 sean media - -"
    "d /srv/backups 0775 sean media - -"
    "d /srv/backups/configs 0775 sean media - -"
  ];

  ########################################
  # Services
  ########################################
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "jellyfin";
    group = "media";
    dataDir = "/var/lib/jellyfin";
    # You'll point Jellyfin libraries to:
    #  - /srv/media/movies
    #  - /srv/media/shows
    #  - /srv/media/fights
  };

  services.sonarr = {
    enable = true; # Web UI on 8989 by default
    dataDir = "/var/lib/sonarr";
    user = "sonarr";
    group = "media";
  };

  services.radarr = {
    enable = true; # Web UI on 7878 by default
    dataDir = "/var/lib/radarr";
    user = "radarr";
    group = "media";
  };

  services.prowlarr = {
    enable = true; # Web UI on 9696 by default
  };

  services.bazarr = {
    enable = true; # Web UI on 6767 by default
    user = "bazarr";
    group = "media";
  };

  services.qbittorrent = {
    enable = true; # Web UI on 8080 by default
    openFirewall = true;
    user = "qbittorrent";
    group = "media";
  };

  services.jellyseerr = {
    enable = true;
    openFirewall = true;
    # Port 5055 by default
  };

  ########################################
  # Firewall (explicitly open the *arr* ports)
  ########################################
  networking.firewall.allowedTCPPorts = [
    8096 # Jellyfin
    9696 # Prowlarr
    7878 # Radarr
    8989 # Sonarr
    6767 # Bazarr
    5055 # Jellyseerr
    8080 # qBittorrent WebUI
  ];

  # If you want to use qBittorrent's default bittorrent ports:
  # networking.firewall.allowedTCPPorts = config.networking.firewall.allowedTCPPorts ++ [ 6881 ];
  # networking.firewall.allowedUDPPorts = [ 6881 ];

  ########################################
  # Systemd Service Dependencies
  ########################################
  # Ensure Jellyfin starts after the *arr services for proper integration
  systemd.services.jellyfin = {
    after = ["sonarr.service" "radarr.service"];
    wants = ["sonarr.service" "radarr.service"];
  };
}
