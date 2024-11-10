#de Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  #  config,
  pkgs,
  pkgs-stable,
  systemSettings,
  lib,
  # nixarr,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./nixarr.nix
    ./system/security/firewall.nix
    ./system/security/vpn.nix
    ./system/security/blocky.nix
    ./system/app/jellyfin.nix
    ./system/hardware/bluetooth.nix
    ./system/app/mysql.nix
    ./system/app/picom.nix
    ./system/wm/x11.nix
    ./system/security/sshd.nix
    #    ./disko-config.nix
    ./system/style/stylix.nix
  ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  #Auto update nix-store at each build
  nix.settings.auto-optimise-store = true;

  # Set the interval for automatic garbage collection (e.g., weekly)
  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than 7d";

  # Adding automatic upgrades of the system
  #   system.autoUpgrade = {
  #   enable = true;
  #   flake = inputs.self.outPath;
  #   flags = [
  #     "--update-input"
  #     "nixpkgs"
  #     "--print-build-logs"
  #   ];
  #   dates = "02:00";
  #   randomizedDelaySec = "45min";
  # };

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = systemSettings.hostname; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  #time.timeZone = "America/New_York";
  time.timeZone = systemSettings.timezone;
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

  # programs.hyprland= {
  #   enable = true;
  #   xwayland.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.

  #  boot.initrd.postDeviceCommands = lib.mkAfter ''
  #   mkdir /btrfs_tmp
  #  mount /dev/root_vg/root /btrfs_tmp
  # if [[ -e /btrfs_tmp/root ]]; then
  #    mkdir -p /btrfs_tmp/old_roots
  #   timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
  #  mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
  #fi

  #delete_subvolume_recursively() {
  #   IFS=$'\n'
  #  for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
  #     delete_subvolume_recursively "/btrfs_tmp/$i"
  # done
  # btrfs subvolume delete "$1"
  #}

  #for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
  #   delete_subvolume_recursively "$i"
  #done

  #btrfs subvolume create /btrfs_tmp/root
  # umount /btrfs_tmp
  #'';

  #  fileSystems."/persist".neededForBoot = true;
  # environment.persistence."/persist/system" = {
  #  hideMounts = true;
  # directories = [
  #  "/etc/nixos"
  # "/var/log"
  # "/var/lib/bluetooth"
  # "/var/lib/nixos"
  # "/var/lib/systemd/coredump"
  # "/etc/NetworkManager/system-connections"
  # "/home/sean/Downloads"
  # "/home/sean/Downloads/dotfiles"
  # ];
  # };

  users.users.sean = {
    isNormalUser = true;
    description = "sean";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [];
    shell = pkgs.nushell;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  # environment.systemPackages = with pkgs-stable; [
  #  pywalfox-native
  #];

  environment.systemPackages =
    (with pkgs; [
      xorg.xorgserver
      xorg.xinit
      vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      wget
      vscode
      vscode-extensions.github.copilot
      #  pkgs-stable.qtile
      # pkgs-stable.python3Packages.qtile-extras
      lightdm
      firefox
      #  chromium
      git
      neofetch
      pfetch
      alacritty
      eza
      starship
      rofi
      rofi-power-menu
      rofi-screenshot
      pywal
      dunst
      xfce.xfce4-power-manager
      xfce.thunar
      expressvpn
      nil
      R
      rstudio
      btop
      figlet
      bluez
      neovim
      unzip
      mpv
      freerdp
      xfce.mousepad
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
      #pkgs-unstable.pywalfox-native
      #pkgs-unstable.codesnap-nvim
      #  spicetify-cli
      #  spotify
      qalculate-gtk
      jetbrains.pycharm-community-src
      nitrogen
      xclip
      alejandra
      black
      google-java-format

      prettierd
      rustfmt
      stylua
      vimPlugins.plenary-nvim
      yazi
      tmux
      zoxide
      fzf
      # nushell
    ])
    ++ (with pkgs-stable; [
      #python311Packages.qtile
      mycli
      python3Packages.qtile-extras
    ]);

  fonts.packages = with pkgs; [
    font-awesome
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

  # Enable the OpenSSH daemon.
  #services.openssh.enable = true;
  #users.users.sean.openssh.authorizedKeys.keys = ["~/.ssh/id_ed25519.pub"];

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
