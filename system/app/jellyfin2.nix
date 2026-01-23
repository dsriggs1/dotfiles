{ config, pkgs, lib, ... }:

{
  ########################################
  # Shared folders & permissions
  ########################################
  # A shared "media" group so all services can read/write the same folders.
  users.groups.media = { };

  # Add your user so you can manage files too.
  users.users.sean.extraGroups = [ "media" ];

  # Add the service users to the media group (these users are created by the modules).
  users.groups.media.members = [
    "jellyfin"
    "prowlarr"
    "radarr"
    "sonarr"
    "qbittorrent"
    "jellyseerr"
  ];

  # Create the directory structure at boot with sane perms.
  # Owner: sean, Group: media, Mode: 0775 (group-writable)
  systemd.tmpfiles.rules = [
    "d /srv 0755 root root - -"
    "d /srv/media 0775 sean media - -"
    "d /srv/media/movies 0775 sean media - -"
    "d /srv/media/tv 0775 sean media - -"
    "d /srv/downloads 0775 sean media - -"
    "d /srv/downloads/incomplete 0775 sean media - -"
    "d /srv/downloads/completed 0775 sean media - -"
  ];

  ########################################
  # Services
  ########################################
  services.jellyfin = {
    enable = true;
    # Optional: auto-open port 8096
    openFirewall = true;
    # You’ll point Jellyfin libraries to:
    #  - /srv/media/movies
    #  - /srv/media/tv
  };

  services.prowlarr.enable = true;  # Web UI on 9696 by default

  services.radarr.enable = true;    # Web UI on 7878 by default
  services.sonarr.enable = true;    # Web UI on 8989 by default

  services.jellyseerr = {
    enable = true;
    # Port 5055 by default
    openFirewall = true;
    # If you want a different port:
    # port = 5055;
  };

  services.qbittorrent = {
    enable = true;
    openFirewall = true;   # opens the WebUI port
    # The module exposes WebUI under 8080 by default; if you want to change it:
    # webUI.port = 8080;
    # You’ll set save paths in the qBittorrent UI to:
    #  - Incomplete: /srv/downloads/incomplete
    #  - Completed:  /srv/downloads/completed
  };

  ########################################
  # Firewall (explicitly open the *arr* ports)
  ########################################
  networking.firewall.allowedTCPPorts = [
    8096  # Jellyfin
    9696  # Prowlarr
    7878  # Radarr
    8989  # Sonarr
    5055  # Jellyseerr
    8080  # qBittorrent WebUI
  ];

  # If you want to use qBittorrent’s default bittorrent ports:
  # networking.firewall.allowedTCPPorts = config.networking.firewall.allowedTCPPorts ++ [ 6881 ];
  # networking.firewall.allowedUDPPorts = [ 6881 ];
}
