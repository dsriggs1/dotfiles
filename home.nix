{
  pkgs,
  userSettings,
  pkgs-stable,
  ...
}: {
  imports = [
    ./user/app/terminal/sh.nix
    # ./firefox.nix
    ./user/app/git/git.nix
    ./user/app/vscode/vscode.nix
    ./user/app/browser/firefox.nix
    ./neovim/nixvim.nix
    ./user/app/tmux/tmux.nix
    ./user/app/tmux/tmuxinator.nix
    ./user/app/terminal/starship.nix
    ./user/app/terminal/zoxide.nix
    ./user/app/plasma-manager/plasma.nix
  ];

  home.username = userSettings.username;
  home.homeDirectory = userSettings.homeDir;

  # Example themes: https://github.com/tinted-theming/schemes/tree/spec-0.11/base16
  # Some example color schemes that can be turned on/off
  stylix.image = ./system/style/lake-sunrise.jpg;
  #stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
  #  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/oxocarbon-dark.yaml";
  #stylix.base16Scheme = "/home/sean/Downloads/dotfiles/themes/cyborg_girl";
  home.packages = with pkgs; [
    git
    vscode
    #    firefox
    tmux
    starship
    tmuxinator
    # pkgs-unstable.vimPlugins.codesnap-nvim
    # qtile
    nushell
  ];

  home.file.".config/qtile/config.py" = {
    source = ./qtile/config.py;
  };

  xdg.userDirs.enable = true;

  xdg.userDirs.createDirectories = true;

  xdg.userDirs = {
    music = "$HOME/Music";
    #  downloads = "$HOME/Downloads";
    documents = "$HOME/Documents";
    pictures = "$HOME/Pictures";
    videos = "$HOME/Videos";
    #  books = "$HOME/Books";

    extraConfig = {
      XDG_BOOKS_DIR = "$HOME/Books";
      XDG_GITHUB_DIR = "$HOME/Github";
    };
  };
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
