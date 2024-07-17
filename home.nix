{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./sh.nix
    # ./firefox.nix
    ./user/app/git/git.nix
    ./user/app/vscode/vscode.nix
    ./neovim/nixvim.nix
  ];

  home.username = "sean";
  home.homeDirectory = "/home/sean";

  #  stylix.image = /home/sean/wallpapers/lake-sunrise.jpg;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";

  home.packages = with pkgs; [
    git
    vscode
    firefox
  ];

  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
          ublock-origin
        ];
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

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
