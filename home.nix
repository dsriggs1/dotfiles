{
  config,
  pkgs,
  lib,
  userSettings,
  keybindings,
  pkgs-stable,
  inputs,
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
    ./user/app/hyprland/hyprland.nix
  ];

  # Allow unfree packages (needed for VSCode, etc.)
  nixpkgs.config.allowUnfree = true;

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
  home.packages =
    (with pkgs; [
      # Browsers & communication
      # firefox - installed via programs.firefox in ./user/app/browser/firefox.nix
      element-desktop

      # Editors & IDEs
      # vscode - installed via programs.vscode in ./user/app/vscode/vscode.nix
      # neovim - installed via nixvim module in ./neovim/nixvim.nix
      jetbrains.pycharm-community-src

      # Terminals
      # alacritty - installed via programs.alacritty.enable in home.nix
      kitty

      # Shell & CLI tools
      # nushell - installed via programs.nushell in ./user/app/terminal/sh.nix
      # starship - installed via programs.starship in ./user/app/terminal/starship.nix
      zoxide # Config only in ./user/app/terminal/zoxide.nix
      eza
      fzf
      btop
      neofetch
      pfetch
      figlet
      gum
      xclip

      # File managers & utilities
      xfce.thunar
      xfce.mousepad
      yazi

      # Media players
      mpv
      vlc
      kodi

      # Document viewers
      kdePackages.okular
      texworks

      # Note-taking & knowledge management
      obsidian

      # Development tools
      # git - installed via programs.git in ./user/app/git/git.nix
      alejandra # Nix formatter
      nil # Nix LSP
      R
      rstudio
      tmuxinator # Config only in ./user/app/tmux/tmuxinator.nix

      # Formatters
      black # Python
      google-java-format # Java
      prettierd # JavaScript/JSON/etc
      rustfmt # Rust
      stylua # Lua

      # Rofi & plugins
      rofi
      rofi-bluetooth
      rofi-power-menu
      rofi-screenshot

      # Desktop utilities
      dunst # Notifications
      pywal # Theming
      inotify-tools
      xautolock
      xfce.xfce4-power-manager
      xfce.tumbler
      pavucontrol # Audio control
      nitrogen # Wallpaper setter
      qalculate-gtk # Calculator

      # KDE/compositor effects
      kdePackages.krohnkite
      kde-rounded-corners

      # Cloud sync
      nextcloud-client
      pcloud

      # Networking & remote
      expressvpn
      freerdp # Remote desktop
      deskflow # Input sharing

      # Containers & dev tools
      distrobox
      dnsmasq

      # Torrents
      qbittorrent

      # AI/productivity
      claude-code

      # Neovim plugins
      vimPlugins.plenary-nvim

      # GitHub SSH setup script
      (writeShellScriptBin "setup-github-ssh" (builtins.readFile ./scripts/setup-github-ssh.sh))
    ])
    ++ (with pkgs-stable; [
      mycli # MySQL client
      python3Packages.qtile-extras
    ])
    ++ [
      inputs.kwin-effects-better-blur-dx.packages.${pkgs.system}.default # Wayland
      inputs.kwin-effects-better-blur-dx.packages.${pkgs.system}.x11 # X11
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
      XDG_OBSIDIAN_DIR = "$HOME/Documents/Obsidian-Vaults";
    };
  };

  # Obsidian vault structure for NixOS notes
  home.file."Documents/Obsidian-Vaults/NixOS-Notes/README.md".text = ''
    # NixOS Configuration Notes

    This vault contains notes, session logs, and documentation from Claude Code sessions and NixOS configuration work.

    ## Vault Structure

    - **ClaudeCode-Sessions/**: Logs and notes from Claude Code work sessions
    - **Configurations/**: Documentation of specific configuration changes
    - **Troubleshooting/**: Solutions to problems encountered
    - **Packages/**: Notes on installed packages and their configurations
    - **Modules/**: Documentation of custom modules and their options

    ## Quick Links

    - [Dotfiles Repository](file:///${userSettings.homeDir}/Github/dotfiles)
    - [CLAUDE.md](file:///${userSettings.homeDir}/Github/dotfiles/CLAUDE.md)
    - [Module Options Documentation](file:///${userSettings.homeDir}/Github/dotfiles/docs/MODULE-OPTIONS.md)
  '';

  home.file."Documents/Obsidian-Vaults/NixOS-Notes/ClaudeCode-Sessions/.gitkeep".text = "";
  home.file."Documents/Obsidian-Vaults/NixOS-Notes/Configurations/.gitkeep".text = "";
  home.file."Documents/Obsidian-Vaults/NixOS-Notes/Troubleshooting/.gitkeep".text = "";
  home.file."Documents/Obsidian-Vaults/NixOS-Notes/Packages/.gitkeep".text = "";
  home.file."Documents/Obsidian-Vaults/NixOS-Notes/Modules/.gitkeep".text = "";

  home.file."Documents/Obsidian-Vaults/NixOS-Notes/ClaudeCode-Sessions/Session-Template.md".text = ''
    # Session - YYYY-MM-DD

    ## Goal
    [What you wanted to accomplish in this session]

    ## Changes Made
    -
    -
    -

    ## Files Modified
    - `path/to/file.nix` - [brief description]

    ## Commands Run
    ```bash
    # Commands used during this session
    ```

    ## Learnings
    -
    -

    ## Follow-up Tasks
    - [ ]
    - [ ]

    ## References
    - [[Related Note]]
    - [External Link]()
  '';

  home.file."Documents/Obsidian-Vaults/NixOS-Notes/Configurations/Configuration-Template.md".text = ''
    # [Configuration Name]

    ## Overview
    [Brief description of what this configuration does]

    ## Location
    `path/to/config.nix`

    ## Key Options
    ```nix
    # Important configuration options
    ```

    ## Related Modules
    - [[Module Name]]

    ## Documentation
    - [Official Docs]()
    - [[Related Configuration]]

    ## Notes
    -
  '';

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
