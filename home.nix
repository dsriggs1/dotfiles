{ config, pkgs, inputs, ... }:

let myAliases = {
  c = "clear";
        nf = "neofetch";
        pf = "pfetch";
        ll = "eza -al --icons";
        lt = "eza -a --tree --level=1 --icons";
        shutdown = "systemctl poweroff";
        v = "$EDITOR";
        ts = "~/dotfiles/scripts/snapshot.sh";
        matrix = "cmatrix";
        wifi = "nmtui";
        od = "~/private/onedrive.sh";
        rw = "~/dotfiles/waybar/reload.sh";
        winclass = "xprop | grep 'CLASS'";
        dot = "cd ~/dotfiles";
        picom = "picom --config ~/.config/picom/picom.conf";
        dotfiles = "cd ~/Downloads/dotfiles";

        # SCRIPTS
        gr = "python ~/dotfiles/scripts/growthrate.py";
        ChatGPT = "python ~/mychatgpt/mychatgpt.py";
        chat = "python ~/mychatgpt/mychatgpt.py";
        ascii = "~/dotfiles/scripts/figlet.sh";

        # VIRTUAL MACHINE
        vm = "~/private/launchvm.sh";
        lg = "~/dotfiles/scripts/looking-glass.sh";
        vmstart = "virsh --connect qemu:///system start win11";
        vmstop = "virsh --connect qemu:///system destroy win11";

        # EDIT CONFIG FILES
        confq = "$EDITOR ~/.config/qtile/config.py";
        confql = "$EDITOR ~/.local/share/qtile/qtile.log";
        confp = "$EDITOR ~/dotfiles/picom/picom.conf";
        confb = "$EDITOR ~/.bashrc";
        confn = "$EDITOR ~/Downloads/dotfiles/configuration.nix";

        # EDIT NOTES
        notes = "$EDITOR ~/notes.txt";

        # NIX SYSTEM
        rebuild = "sudo nixos-rebuild switch";

        # SCREEN RESOLUTIONS
        res1 = "xrandr --output DisplayPort-0 --mode 2560x1440 --rate 120";
        res2 = "xrandr --output DisplayPort-0 --mode 1920x1080 --rate 120";
};

in 
{
    home.username = "sean";
    home.homeDirectory = "/home/sean";

  #  stylix.image = /home/sean/wallpapers/lake-sunrise.jpg;

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

    programs.bash = {
      enable = true;      
      # home.sessionVariables = {
      #   EDITOR = "code"; # replace "vim" with your preferred editor
      # };

      shellAliases = myAliases;

      initExtra = ''
        cd() {
          builtin cd "$@" && ls -la
        }
      '';
    };

    programs.zsh = {
      enable = true;      
      # home.sessionVariables = {
      #   EDITOR = "code"; # replace "vim" with your preferred editor
      # };

      shellAliases = myAliases;

      initExtra = ''
        cd() {
          builtin cd "$@" && ls -la
        }
      '';
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