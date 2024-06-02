{ config, pkgs, inputs, ... }:

{
    home.username = "sean";
    home.homeDirectory = "/home/sean";

  # home-manager.sharedModules = [{
  #   stylix.targets.xyz.enable = false;
  # }];

# home-manager.users.sean = { pkgs, ... }: {
#     nixpkgs.config = {
#       allowUnfree = true;
#     }; 

    home.packages = with pkgs; [
        git
        vscode
        firefox
    ];

    programs.git = {
      enable = true;
      userName = "dsriggs1";
      userEmail = "dsriggs1@gmail.com";
      aliases =
        {
          a = "add";
          c = "commit";
          ca = "commit --amend";
          can = "commit --amend --no-edit";
          cl = "clone";
          cm = "commit -m";
          co = "checkout";
          cp = "cherry-pick";
          cpx = "cherry-pick -x";
          d = "diff";
          f = "fetch";
          fo = "fetch origin";
          fu = "fetch upstream";
          gds = "diff --staged";
          lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
          lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
          pl = "pull";
          pr = "pull -r";
          ps = "push";
          psf = "push -f";
          rb = "rebase";
          rbi = "rebase -i";
          r = "remote";
          ra = "remote add";
          rr = "remote rm";
          rv = "remote -v";
          rs = "remote show";
          st = "status";
      };
    };

    programs.vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        github.copilot
        ms-python.python
        jnoortheen.nix-ide        
      ];
      
    };

 
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
              tags = [ "nixos" ];
              keyword = "nixos";
              url = "https://wiki.nixos.org/wiki/NixOS_Wiki"; 
            }
            {
              
              name = "Jellyfin Server";
              tags = [ "Jellyfin" ];
              keyword = "Jellyfin";
              url = "http://localhost:8096";              
            }

            {
              name = "Bazarr";
              tags = [ "Bazarr" ];
              keyword = "Bazarr";
              url = "http://localhost:6767";
            }

            {  
              name = "Lidarr";
              tags = [ "Lidarr" ];
              keyword = "Lidarr";
              url = "http://localhost:8686";
            }

            {
              name = "Prowlarr";
              tags = [ "Prowlarr" ];
              keyword = "Prowlarr";
              url = "http://localhost:9696";
            }

            {
              name = "Radarr";
              tags = [ "Radarr" ];
              keyword = "Radarr";
              url = "http://localhost:7878";
            }
            
            {
              name = "Sonarr";
              tags = [ "Sonarr" ];
              keyword = "Sonarr";
              url = "http://localhost:8989";
            }

            {
              name = "github";
              tags = [ "github" ];
              keyword = "github";
              url = "https://github.com/";
              
            }            
          ]; 
          };
          };           
        };         
      };
    };
  #};
        
    home.stateVersion = "23.11";
    programs.home-manager.enable = true;
}