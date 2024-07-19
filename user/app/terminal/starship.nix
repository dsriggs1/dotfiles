{...}: {
  programs.starship = {
    enable = true;
  };
  programs.starship.settings = {
    # See docs here: https://starship.rs/config/
    # Symbols config configured ./starship-symbols.nix.
    hostname.style = "bold pink";
    #hostname.ssh_only = false;
    username.show_always = true;
    username.style_user = "bold red"; # don't like the default
    "$schema" = "https://starship.rs/config-schema.json";
  };
  programs.dircolors.enableBashIntegration = true;
  programs.starship.enableBashIntegration = true;
}
