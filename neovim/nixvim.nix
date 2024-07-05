{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./options.nix
    ./keymaps.nix
    ./nvim-tree.nix
    ./conform.nix
    ./autocommands.nix
    ./nvim-notify.nix
    ./lsp.nix
    ./completion.nix
    ./codeium.nix
    #    ./copilot.nix
    ./copilot-lua.nix
    ./treesitter.nix
    # ./neogit.nix
    ./telescope.nix
    ./fugitive.nix
    ./tmux-navigator.nix
    #    ./codesnap.nix
  ];
  programs.nixvim = {
    enable = true;

    globals.mapleader = " ";
  };
}
