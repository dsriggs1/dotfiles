{
  pkgs,
  lib,
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
  stylix.targets.gnome.enable = false;
  #stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
  #  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/oxocarbon-dark.yaml";
  #stylix.base16Scheme = "/home/sean/Downloads/dotfiles/themes/cyborg_girl";
  home.packages = with pkgs; [
    git
    vscode
    #    firefox
    starship
    tmuxinator
    # pkgs-unstable.vimPlugins.codesnap-nvim
    # qtile
    nushell
    pfetch
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

  # Automatically clone GitHub repositories on first setup
  home.activation.cloneGithubRepos = lib.hm.dag.entryAfter ["writeBoundary"] ''
    GITHUB_DIR="${userSettings.homeDir}/Github"

    # Ensure directory exists
    mkdir -p "$GITHUB_DIR"

    # List of repos to clone
    repos=(
      "https://github.com/dsriggs1/dotfiles.git"
      "https://github.com/dsriggs1/retrosheet.git"
      "https://github.com/dsriggs1/Resume.git"
      "https://github.com/dsriggs1/Baseball_Project.git"
      "https://github.com/dsriggs1/Rcpp-Library.git"
    )

    for repo in "''${repos[@]}"; do
      repo_name=$(basename "$repo" .git)
      if [ ! -d "$GITHUB_DIR/$repo_name" ]; then
        echo "Cloning $repo_name..."
        $DRY_RUN_CMD ${pkgs.git}/bin/git clone "$repo" "$GITHUB_DIR/$repo_name"
      else
        echo "Repository $repo_name already exists, skipping..."
      fi
    done
  '';

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
