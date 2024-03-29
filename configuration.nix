# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, pkgs-unstable, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #<home-manager/nixos>
    ];

   nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # home-manager.users.sean = { pkgs, ... }: {
  #   nixpkgs.config = {
  #     allowUnfree = true;
  #   }; 
  #   home.packages = [ pkgs.atool pkgs.httpie ];
  #   programs.git = {
  #     enable = true;
  #     userName = "dsriggs1";
  #     userEmail = "dsriggs1@gmail.com";
  #     aliases =
  #       {
  #         a = "add";
  #         c = "commit";
  #         ca = "commit --amend";
  #         can = "commit --amend --no-edit";
  #         cl = "clone";
  #         cm = "commit -m";
  #         co = "checkout";
  #         cp = "cherry-pick";
  #         cpx = "cherry-pick -x";
  #         d = "diff";
  #         f = "fetch";
  #         fo = "fetch origin";
  #         fu = "fetch upstream";
  #         gds = "diff --staged";
  #         lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
  #         lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
  #         pl = "pull";
  #         pr = "pull -r";
  #         ps = "push";
  #         psf = "push -f";
  #         rb = "rebase";
  #         rbi = "rebase -i";
  #         r = "remote";
  #         ra = "remote add";
  #         rr = "remote rm";
  #         rv = "remote -v";
  #         rs = "remote show";
  #         st = "status";
  #     };
  #   };

  #   programs.vscode = {
  #     enable = true;
  #     extensions = with pkgs.vscode-extensions; [
  #       github.copilot
  #     ];
  #   };    
  #   home.stateVersion = "23.11";
  # };


  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  #Configure keymap in X11
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "";
    windowManager.qtile = {
      enable = true;
      # extraPackages =
      # python3Packages: with
      # python3Packages; [
      #    (qtile-extras.overridePythonAttrs(old: { disabledTestPaths = [ "test/widget/test_strava.py" ]; }))
      #   # qtile-extras
      # ];
      
   };
   #desktopManager.xfce.enable = true;
   #desktopManager.plasma5.enable = true;
   displayManager = {
      lightdm = {
        enable = true;
        
        #Slick greeter configuration
        greeters.slick = {
          enable = true;
          #background = "~/wallpapers/default.jpg"; 
          theme.name = "Nordic-darker";
        };
      };
    };
  
  };

  programs.hyprland= {
    enable = true;
    xwayland.enable = true;
    nvidiaPatches = true;
  };

#   services.xserver.windowManager.qtile = {
#     ...
#     extraPackages = python3Packages: with python3Packages; [
#        ...
#         (qtile-extras.overridePythonAttrs(old: { disabledTestPaths = [ "test/widget/test_strava.py" ]; }))
#     ];
# };

  
  #services.xserver.windowManager.qtile.extraPackages = p: with p; [ qtile-extras ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sean = {
    isNormalUser = true;
    description = "sean";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  # environment.systemPackages = with pkgs-unstable; [
  #   pywalfox-native
  # ];

  environment.systemPackages = with pkgs; [
   xorg.xorgserver
   xorg.xinit
   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
   wget
   vscode
   vscode-extensions.github.copilot
   qtile
   lightdm
   firefox
   git
   neofetch
   pfetch
   alacritty
   eza
   starship
   rofi
   pywal
   dunst
   xfce.xfce4-power-manager
   xfce.thunar
   expressvpn
   nil
   R
   rstudio
   btop
   python311Packages.pytorch-metric-learning
   python311Packages.psutil
   python311Packages.rich
   python311Packages.click
   figlet
   bluez
   neovim
   unzip
   mpv
   freerdp
   xfce.mousepad
   noto-fonts
   fira
   fira-code
   vlc
   pavucontrol
   xfce.tumbler
   xautolock
   papirus-icon-theme
   polkit_gnome
   qalculate-gtk
   brightnessctl
   gum
   man-pages
   xdg-desktop-portal
   networkmanagerapplet
   gvfs
   xdg-user-dirs
   jellyfin
   jellyfin-web
   jellyfin-ffmpeg
   qbittorrent
   kitty
   pkgs-unstable.pywalfox-native
  ];  

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
#   services.picom = {
#   enable = true;
#   #backend="glx";
#    settings = {
#     extraConfig = ''
#     inactive-opacity = 0.7
#     active-opacity =1;
#     opacity-rule = [
#    	"90:class_g = 'Alacritty' && focused",
# 	"70:class_g = 'Alacritty' && !focused",
# 	"70:class_g = 'Rofi'",
#   "70:class_g = 'firefox'",
#   "70:class_g = 'code'"
#     ];
#     '';
#   };
#      #extraConfig = builtins.readFile "/etc/nixos/picom.conf";
#   #};
# };

  services.picom = {
    enable = true;
    fade = true;
    inactiveOpacity = 0.7;
    activeOpacity = 1;
    settings = {
      blur = {
        method = "guassian";
        size=10;
        deviation=5.0;
      };
    };
  };


  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    ensureDatabases = [ "retrosheet" ];
    ensureUsers = [
      {
        name = "sean";
        ensurePermissions = {
          "retrosheet.*" = "ALL PRIVILEGES";
        };
      }
    ];
  };
  
  services.expressvpn = {
    enable =true;
  };

  services.blueman = {
    enable = true;
  };

  services.jellyfin = {
    enable = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  users.users.sean.openssh.authorizedKeys.keys =["~/.ssh/id_ed25519.pub"];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
