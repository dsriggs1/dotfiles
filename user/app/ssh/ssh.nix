{...}: {
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        host = "github.com";
        identityFile = "~/.ssh/github";
        identitiesOnly = true;
      };

      # Ann's laptop
      "Ann-laptop" = {
        host = "192.168.1.238";
        user = "sean";
        identityFile = "~/.ssh/id_ed25519";
      };

      # Sean's work machine
      "sean-work" = {
        host = "192.168.1.208";
        user = "sean";
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };
}
