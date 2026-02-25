{pkgs, ...}: {
  programs.nixvim = {
    plugins.vim-dadbod = {
      enable = true;
    };

    # Add vim-dadbod-ui and completion
    extraPlugins = with pkgs.vimPlugins; [
      vim-dadbod-ui
      vim-dadbod-completion
    ];

    # Keybindings
    keymaps = [
      {
        mode = "n";
        key = "<leader>db";
        action = "<cmd>DBUI<cr>";
        options.desc = "Open database UI";
      }
    ];
  };
}
