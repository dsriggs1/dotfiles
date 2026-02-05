{
  pkgs,
  pkgs-stable,
  ...
}:
#xserver nix install xserver
{
  services.xserver = {
    enable = true;
    dpi = 96;
    layout = "us";
    xkbVariant = "";
    windowManager.qtile = {
      enable = true;
      extraPackages = python312Packages:
        with pkgs-stable.python312Packages; [
          # qtile-extras
        ];
    };
    #desktopManager.xfce.enable = true;
    desktopManager.plasma6.enable = true;
    displayManager = {
      sddm = {
        # background = "/etc/nixos/background/default.jpg";
        enable = true;

        #Slick greeter configuration
        #  greeters.slick = {
        #   enable = true;
        #  theme.name = "Adwaita";

        # extraConfig = ''
        #    user-background = false
        #'';
        # };
      };
    };
  };
}
