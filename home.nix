{
  config,
  pkgs,
  lib,
  userSettings,
  keybindings,
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
  stylix.image = ./wallpapers/Fantasy-Autumn.png;
  stylix.targets.gnome.enable = false;
  programs.alacritty.enable = true;
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
    # GitHub SSH setup script
    (writeShellScriptBin "setup-github-ssh" (builtins.readFile ./scripts/setup-github-ssh.sh))
  ];

  home.file.".config/stylix/wallpaper".source = config.stylix.image;

  home.file.".config/stylix/fonts.json" = {
    text = builtins.toJSON {
      desktop = config.stylix.fonts.sizes.desktop;
      applications = config.stylix.fonts.sizes.applications;
      terminal = config.stylix.fonts.sizes.terminal;
    };
  };

  home.file.".config/qtile/keybindings.json" = {
    text = builtins.toJSON keybindings;
  };

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

  # Automatically setup GitHub SSH key on first activation
  home.activation.setupGithubSSH = lib.hm.dag.entryAfter ["writeBoundary"] ''
        SSH_KEY="${userSettings.homeDir}/.ssh/github"
        SSH_PUB="$SSH_KEY.pub"
        NOTICE_FILE="${userSettings.homeDir}/GITHUB_SSH_SETUP.txt"

        if [ ! -f "$SSH_KEY" ]; then
          # Ensure .ssh directory exists with correct permissions
          mkdir -p "${userSettings.homeDir}/.ssh"
          chmod 700 "${userSettings.homeDir}/.ssh"

          # Generate SSH key
          ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -C "dsriggs1@gmail.com" -f "$SSH_KEY" -N "" -q
          chmod 600 "$SSH_KEY"
          chmod 644 "$SSH_PUB"

          # Create notice file with instructions
          cat > "$NOTICE_FILE" << 'NOTICE_EOF'
    ==========================================
       GitHub SSH Key Generated!
    ==========================================

    Your new SSH key has been generated at:
      ~/.ssh/github

    Add this public key to GitHub:
    ------------------------------------------
    NOTICE_EOF
          cat "$SSH_PUB" >> "$NOTICE_FILE"
          cat >> "$NOTICE_FILE" << 'NOTICE_EOF'
    ------------------------------------------

    Next Steps:
    1. Copy the public key above
    2. Visit: https://github.com/settings/ssh/new
    3. Paste the key and give it a title
    4. Click 'Add SSH key'
    5. Test with: ssh -T git@github.com

    After adding to GitHub, update your dotfiles remote:
      cd ~/Downloads/dotfiles
      git remote set-url origin git@github.com:YOUR_USERNAME/dotfiles.git

    Delete this file after completing setup:
      rm ~/GITHUB_SSH_SETUP.txt
    ==========================================
    NOTICE_EOF

          echo "" >&2
          echo "=========================================="
          echo "   GitHub SSH Key Generated!"
          echo "   See ~/GITHUB_SSH_SETUP.txt for details"
          echo "=========================================="
          echo ""
        fi
  '';

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
