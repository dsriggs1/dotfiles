{ config, pkgs, ... }:

{
    home.username = "sean";
    home.homeDirectory = "/home/sean";

# home-manager.users.sean = { pkgs, ... }: {
#     nixpkgs.config = {
#       allowUnfree = true;
#     }; 
    home.packages = with pkgs; [
        git
        vscode
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
      ];
    };
        
    home.stateVersion = "23.11";
    programs.home-manager.enable = true;
  }