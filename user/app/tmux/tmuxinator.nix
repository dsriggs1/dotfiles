{...}: {
  home.file = {
    ".config/tmuxinator/nixos.yml".text = ''
      name: nixos
      root: ~/Downloads/dotfiles
      windows:
        - main:
            layout: main-horizontal
            panes:
              - nvim
              - bash

    '';
  };
  home.file = {
    ".config/tmuxinator/nixos_nvim.yml".text = ''
      name: nixos_nvim
      root: ~/Downloads/dotfiles/neovim
      windows:
        - main:
            layout: main-horizontal
            panes:
              - nvim
              - shell: nushell

    '';
  };
  home.file = {
    ".config/tmuxinator/baseball.yml".text = ''
      name: baseball
      root: ~/Downloads/Baseball_Project/
      windows:
        - main:
            layout: main-vertical
            panes:
              - nvim
              - shell: nushell
              - shell: mycli
    '';
  };
}
