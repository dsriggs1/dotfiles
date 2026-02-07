{pkgs, ...}: {
  stylix.enable = true;
  stylix.image = ../../wallpapers/Fantasy-Autumn.png;
  stylix.polarity = "dark";
  stylix.cursor.size = 24;
  stylix.fonts.sizes.applications = 12;
  stylix.fonts.sizes.desktop = 12;
  stylix.fonts.sizes.terminal = 12;

  stylix.cursor.package = pkgs.bibata-cursors;
  stylix.cursor.name = "Bibata-Modern-Ice";
  #  stylix.opacity.terminal = 0.7;
  # stylix.opacity.applications = 0.7;
  #stylix.fonts = {
  #monospace = {
  #package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
  #name = "JetBrainsMono Nerd Font Mono";
  #};
  #sansSerif = {
  #package = pkgs.dejavu_fonts;
  #name = "DejaVu Sans";
  #};
  #serif = {
  #package = pkgs.dejavu_fonts;
  #name = "DejaVu Serif";
  #};
  #};
}
