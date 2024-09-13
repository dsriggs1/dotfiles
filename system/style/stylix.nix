{pkgs, ...}: {
  stylix.image = /home/sean/wallpapers/lake-sunrise.jpg;
  stylix.polarity = "dark";
  stylix.cursor.size = 8;
  stylix.fonts.sizes.applications = 10;
  stylix.fonts.sizes.desktop = 5;

  stylix.cursor.package = pkgs.bibata-cursors;
  stylix.cursor.name = "Bibata-Modern-Ice";

  stylix.fonts = {
    monospace = {
      package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
      name = "JetBrainsMono Nerd Font Mono";
    };
    sansSerif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Sans";
    };
    serif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Serif";
    };
  };
}
