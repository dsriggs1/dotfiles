{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "dsriggs1";
        email = "dsriggs1@gmail.com";
      };
      alias = {
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
      # Automatically use SSH instead of HTTPS for GitHub
      url."git@github.com:".insteadOf = "https://github.com/";
    };
  };

  # Configure SSH for GitHub
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        host = "github.com";
        identityFile = "~/.ssh/github";
        identitiesOnly = true;
      };
    };
  };
}
