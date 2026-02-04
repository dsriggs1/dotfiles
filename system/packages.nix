{
  pkgs,
  pkgs-stable,
  inputs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages =
    (with pkgs; [
      xorg.xorgserver
      xorg.xinit
      vim
      wget
      vscode
      vscode-extensions.github.copilot
      lightdm
      firefox
      git
      neofetch
      pfetch
      alacritty
      eza
      starship
      rofi
      rofi-bluetooth
      rofi-power-menu
      rofi-screenshot
      pywal
      dunst
      inotify-tools
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
      zoxide
      fzf
      nushell
      nextcloud-client
      pcloud
      deskflow
      distrobox
      dnsmasq
      element-desktop
      kodi
      kdePackages.okular
      kdePackages.krohnkite
      kde-rounded-corners
      texworks
      claude-code
    ])
    ++ (with pkgs-stable; [
      mycli
      python3Packages.qtile-extras
    ])
    ++ [
      inputs.kwin-effects-better-blur-dx.packages.${pkgs.system}.default # Wayland
      inputs.kwin-effects-better-blur-dx.packages.${pkgs.system}.x11 # X11
    ];

  fonts.packages = with pkgs; [
    font-awesome
  ];
}
