{...}: {
  home.file = {
    ".config/tmuxinator/my_project.yml".text = ''
      name: my_project
      root: ~/projects/my_project
      windows:
        - editor:
            layout: main-vertical
            panes:
              - vim
              - bash
        - server: bundle exec rails server
    '';

    ".config/tmuxinator/another_project.yml".text = ''
      name: another_project
      root: ~/projects/another_project
      windows:
        - shell: bash
        - editor: vim
    '';
  };

  # Other Home Manager configurations...
}
