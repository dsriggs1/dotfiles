{
  pkgs,
  config,
  ...
}: {
  programs.tmux = {
    enable = true;
    package = pkgs.tmux.overrideAttrs (oldAttrs: rec {
      version = "3.5a";
      src = pkgs.fetchFromGitHub {
        owner = "tmux";
        repo = "tmux";
        rev = version;
        hash = "sha256-Z9XHpyh4Y6iBI4+SfFBCGA8huFJpRFZy9nEB7+WQVJE=";
      };
    });
    shortcut = "a";
    # aggressiveResize = true; -- Disabled to be iTerm-friendly
    baseIndex = 1;
    newSession = true;
    # Stop tmux+escape craziness.
    escapeTime = 0;
    # Force tmux to use /tmp for sockets (WSL2 compat)
    secureSocket = false;

    # Enable mouse support
    mouse = true;

    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
      tmuxPlugins.cpu
    ];
    extraConfig = ''
      # Stylix-aware pane borders
      set -g pane-border-style 'fg=#${config.lib.stylix.colors.base03}'
      set -g pane-active-border-style 'fg=#${config.lib.stylix.colors.base0B},bold'


                  is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
                | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"
            bind-key -n "C-h" if-shell "$is_vim" "send-keys C-h"  "select-pane -L"
            bind-key -n "C-j" if-shell "$is_vim" "send-keys C-j"  "select-pane -D"
            bind-key -n "C-k" if-shell "$is_vim" "send-keys C-k"  "select-pane -U"
            bind-key -n "C-l" if-shell "$is_vim" "send-keys C-l"  "select-pane -R"

            tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
            if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
                "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
            if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
                "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

            bind-key -T copy-mode-vi "C-h" select-pane -L
            bind-key -T copy-mode-vi "C-j" select-pane -D
            bind-key -T copy-mode-vi "C-k" select-pane -U
            bind-key -T copy-mode-vi "C-l" select-pane -R
      #      bind-key -T copy-mode-vi "C-\" select-pane -l

      # Vim-style pane resizing
      bind -r h resize-pane -L 5
      bind -r j resize-pane -D 5
      bind -r k resize-pane -U 5
      bind -r l resize-pane -R 5

      # Vim-style pane splitting
      bind v split-window -h -c "#{pane_current_path}"
      bind s split-window -v -c "#{pane_current_path}"

      # Kill pane without confirmation
      bind q kill-pane

      # Custom keybinding cheat sheet
      bind ? display-popup -E -w 50 -h 18 "printf '╔════════════════════════════════════════════╗\n║     Tmux Keybindings (Ctrl+a)             ║\n╠════════════════════════════════════════════╣\n║ PANES                                     ║\n║  v        vertical split                  ║\n║  s        horizontal split                ║\n║  q        close pane                      ║\n║  hjkl     resize pane (repeatable)        ║\n║                                           ║\n║ NAVIGATION                                ║\n║  Ctrl+hjkl    navigate panes/vim          ║\n║                                           ║\n║ OTHER                                     ║\n║  ?        show this help                  ║\n║  :        command prompt                  ║\n║  d        detach session                  ║\n║  c        new window                      ║\n╚════════════════════════════════════════════╝'"

      # Vi-style keys in copy mode
      setw -g mode-keys vi
      bind-key -T copy-mode-vi 'v' send -X begin-selection

      # Dual X11/Wayland clipboard support
      # Auto-detect display server and use appropriate clipboard tool
      %if "#{!=:$WAYLAND_DISPLAY,}"
        # Wayland (using wl-clipboard)
        # PRIMARY selection: highlight-to-copy, middle-click-to-paste
        bind-key -T copy-mode-vi MouseDragEnd1Pane send -X copy-pipe-and-cancel "wl-copy --primary"
        bind-key -T root MouseDragEnd1Pane send -X copy-pipe "wl-copy --primary"
        bind-key -n MouseDown2Pane run "wl-paste --primary | tmux load-buffer - && tmux paste-buffer"
        # CLIPBOARD: explicit copy with 'y' for Ctrl+V paste
        bind-key -T copy-mode-vi 'y' send -X copy-pipe-and-cancel "wl-copy"
      %else
        # X11 (using xclip)
        # PRIMARY selection: highlight-to-copy, middle-click-to-paste
        bind-key -T copy-mode-vi MouseDragEnd1Pane send -X copy-pipe-and-cancel "xclip -selection primary -i"
        bind-key -T root MouseDragEnd1Pane send -X copy-pipe "xclip -selection primary -i"
        bind-key -n MouseDown2Pane run "xclip -selection primary -o | tmux load-buffer - && tmux paste-buffer"
        # CLIPBOARD: explicit copy with 'y' for Ctrl+V paste
        bind-key -T copy-mode-vi 'y' send -X copy-pipe-and-cancel "xclip -selection clipboard -i"
      %endif

      # Powerline status bar - bottom
      set-option -g status-position bottom

      # Status bar styling with stylix colors
      set -g status-style 'bg=#${config.lib.stylix.colors.base00},fg=#${config.lib.stylix.colors.base05}'
      set -g status-left-length 50
      set -g status-right-length 150

      # Left: Session name with powerline
      set -g status-left "#[bg=#${config.lib.stylix.colors.base0D},fg=#${config.lib.stylix.colors.base00},bold] #S #[bg=#${config.lib.stylix.colors.base00},fg=#${config.lib.stylix.colors.base0D}]"

      # Window list with powerline
      set -g window-status-format "#[fg=#${config.lib.stylix.colors.base04}] #I:#W "
      set -g window-status-current-format "#[bg=#${config.lib.stylix.colors.base0C},fg=#${config.lib.stylix.colors.base00}]#[bg=#${config.lib.stylix.colors.base0C},fg=#${config.lib.stylix.colors.base00},bold] #I:#W #[bg=#${config.lib.stylix.colors.base00},fg=#${config.lib.stylix.colors.base0C}]"
      set -g window-status-separator ""

      # Right: Pane index | Current path | CPU & RAM
      set -g status-right "#[fg=#${config.lib.stylix.colors.base03}]#[bg=#${config.lib.stylix.colors.base03},fg=#${config.lib.stylix.colors.base05}] Pane #{pane_index} #[fg=#${config.lib.stylix.colors.base0B}]#[bg=#${config.lib.stylix.colors.base0B},fg=#${config.lib.stylix.colors.base00}]  #{b:pane_current_path} #[fg=#${config.lib.stylix.colors.base0E}]#[bg=#${config.lib.stylix.colors.base0E},fg=#${config.lib.stylix.colors.base00},bold]  #{cpu_percentage}  #{ram_percentage} "

      # Update status bar every 2 seconds
      set -g status-interval 2

      set -g @plugin 'tmux-plugins/tpm'
    '';
  };
}
