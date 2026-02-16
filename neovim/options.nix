{
  programs.nixvim = {
    opts = {
      number = true; # Show line numbers
      relativenumber = true; # Show relative line numbers

      shiftwidth = 2; # Tab width should be 2
      completeopt = ["menu" "menuone" "noselect"];

      # Enable system clipboard integration
      # "unnamedplus" uses + register (CLIPBOARD) for y/d/c/p operations
      clipboard = "unnamedplus";

      # Enable mouse support for auto-yank
      mouse = "a";
    };
  };
}
