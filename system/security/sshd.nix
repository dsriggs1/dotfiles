{...}: {
  services.openssh = {
    enable = true;
  };
  users.users.sean.openssh.authorizedKeys.keys = ["~/.ssh/id_ed25519.pub"];
}
