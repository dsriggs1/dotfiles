{
  pkgs,
  inputs,
  ...
}: {
  programs.zen-browser = {
    enable = true;
    profiles = {
      default = {
        extensions.packages = with inputs.firefox-addons.packages.${pkgs.system}; [
          ublock-origin
          istilldontcareaboutcookies
        ];
        settings = {
          "browser.toolbars.bookmarks.visibility" = "always";
        };
        userChrome = ''
          /* Fix bookmarks toolbar auto-hide issue */
          #zen-appcontent-navbar-container {
            height: var(--zen-toolbar-height) !important;
            opacity: 1 !important;
          }

          #PersonalToolbar {
            opacity: 1 !important;
          }
        '';
        bookmarks = {
          force = true;
          settings = [
            {
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
            }
          ];
        };
        pins = {
          "nixos-wiki" = {
            id = "e60f62d4-7b0a-492d-b524-8da67b4019a1";
            url = "https://wiki.nixos.org/wiki/NixOS_Wiki";
            isEssential = true;
            position = 1;
          };
          "jellyfin" = {
            id = "6dd096f0-dd26-48df-ba70-c0251a941626";
            url = "http://localhost:8096";
            isEssential = true;
            position = 2;
          };
          "bazarr" = {
            id = "6578fd8d-9df5-45a0-b9e2-9925cc889dbc";
            url = "http://localhost:6767";
            isEssential = true;
            position = 3;
          };
          "lidarr" = {
            id = "45a1fe68-0428-4684-80d6-fdb9f89fec9a";
            url = "http://localhost:8686";
            isEssential = true;
            position = 4;
          };
          "prowlarr" = {
            id = "876ebb8f-00df-4864-8e54-6e9c6c98354f";
            url = "http://localhost:9696";
            isEssential = true;
            position = 5;
          };
          "radarr" = {
            id = "8c9b8fd6-ea3a-4b94-8f1c-e74aedd72b47";
            url = "http://localhost:7878";
            isEssential = true;
            position = 6;
          };
          "sonarr" = {
            id = "3a7103d1-cce2-49a9-a2e2-02fc2d7766c3";
            url = "http://localhost:8989";
            isEssential = true;
            position = 7;
          };
          "github" = {
            id = "55301467-b28b-4a0f-b741-126f7bf5e348";
            url = "https://github.com/";
            isEssential = true;
            position = 8;
          };
        };
      };
    };
  };
}
