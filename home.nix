{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./sh.nix
    # ./firefox.nix
    ./user/app/git/git.nix
    ./user/app/vscode/vscode.nix
    ./user/app/browser/firefox.nix
    ./neovim/nixvim.nix
  ];

  home.username = "sean";
  home.homeDirectory = "/home/sean";

  #  stylix.image = /home/sean/wallpapers/lake-sunrise.jpg;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";

  home.packages = with pkgs; [
    git
    vscode
    firefox
  ];

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
