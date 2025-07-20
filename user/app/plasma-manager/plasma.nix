{...}: {
  imports = [
    ./hotkeys.nix
    ./panels.nix
    ./shortcuts.nix
    ./kwin.nix
    ./window-rules.nix
    ./config-files.nix
  ];
  programs.plasma = {
    enable = true;

    #
    # Some high-level settings:
    #
    workspace = {
      clickItemTo = "select";
      lookAndFeel = "org.kde.breezedark.desktop";
      # cursor.theme = "Bibata-Modern-Ice";
      #     iconTheme = "Papirus-Dark";
      # wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Patak/contents/images/1080x1920.png";
    };
  };
}
