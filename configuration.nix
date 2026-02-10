#de Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  #  config,
  pkgs,
  systemSettings,
  # nixarr,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    #    ./nixarr.nix
    ./system/security/firewall.nix
    ./system/security/vpn.nix
    ./system/security/blocky.nix
    ./system/security/pam.nix
    ./system/app/jellyfin.nix
    ./system/hardware/bluetooth.nix
    ./system/app/mysql.nix
    ./system/app/picom.nix
    ./system/app/btrbk.nix
    ./system/wm/x11.nix
    ./system/wm/hyprland.nix
    ./system/security/sshd.nix
    (import ./disko/btrfs-subvolumes.nix {device = systemSettings.device;})
    ./system/style/stylix.nix
    ./system/packages.nix
    ./system/users.nix
    ./impermanence.nix
    ./system/hardware/power.nix
    ./system/app/virt-manager.nix
    ./system/app/distrobox.nix
  ];

  nix = {
    package = pkgs.nixVersions.stable;
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

  # Bootloader - Robust configuration for VMs and physical hardware
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.useOSProber = true;

  # Enable firmware for WiFi and other hardware
  hardware.enableRedistributableFirmware = true;

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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  #jellyseerr service
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
