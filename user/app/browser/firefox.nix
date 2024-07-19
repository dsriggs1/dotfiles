{
  pkgs,
  inputs,
  ...
}: {
  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        #        extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
        #         ublock-origin
        #      ];
        bookmarks = {
          toolbar = {
            name = "My Toolbar";
            toolbar = true;

            bookmarks = [
              {
                name = "Nixos Wiki";
                tags = ["nixos"];
                keyword = "nixos";
                url = "https://wiki.nixos.org/wiki/NixOS_Wiki";
              }
              {
                name = "Jellyfin Server";
                tags = ["Jellyfin"];
                keyword = "Jellyfin";
                url = "http://localhost:8096";
              }

              {
                name = "Bazarr";
                tags = ["Bazarr"];
                keyword = "Bazarr";
                url = "http://localhost:6767";
              }

              {
                name = "Lidarr";
                tags = ["Lidarr"];
                keyword = "Lidarr";
                url = "http://localhost:8686";
              }

              {
                name = "Prowlarr";
                tags = ["Prowlarr"];
                keyword = "Prowlarr";
                url = "http://localhost:9696";
              }

              {
                name = "Radarr";
                tags = ["Radarr"];
                keyword = "Radarr";
                url = "http://localhost:7878";
              }

              {
                name = "Sonarr";
                tags = ["Sonarr"];
                keyword = "Sonarr";
                url = "http://localhost:8989";
              }

              {
                name = "github";
                tags = ["github"];
                keyword = "github";
                url = "https://github.com/";
              }
            ];
          };
        };
      };
    };
  };
}
