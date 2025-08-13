{...}: {
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    dataDir = "/srv/jellyfin";
    logDir = "/srv/jellyfin/log";
  };
  systemd.tmpfiles.rules = [
    "d /srv/media/movies 0750 jellyfin jellyfin -"
    "d /srv/media/shows 0750 jellyfin jellyfin -"
    "d /srv/media/fights 0750 jellyfin jellyfin -"
  ];
}
