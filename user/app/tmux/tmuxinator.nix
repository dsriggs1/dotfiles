{...}: {
  home.file = {
    ".config/tmuxinator/nixos.yml".text = ''
      name: nixos
      root: ~/Downloads/dotfiles
      windows:
        - main:
            layout: main-horizontal
            panes:
              - vim
              - shell: bash

    '';
  };
}
