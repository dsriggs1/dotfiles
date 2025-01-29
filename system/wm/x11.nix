{
  pkgs,
  pkgs-stable,
  lib,
  ...
}:
#xserver nix install xserver
{
  services.xserver = {
    enable = true;
    videoDrivers = ["displaylink" "modesetting"];
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
    #desktopManager.plasma5.enable = true;
    displayManager = {
      sessionCommands = ''
        ${lib.getBin pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 2 0'';
      lightdm = {
        # background = "/etc/nixos/background/default.jpg";
        enable = true;

        #Slick greeter configuration
        greeters.slick = {
          enable = true;
          theme.name = "Adwaita";

          extraConfig = ''
            user-background = false
          '';
        };
      };
    };
  };
}
