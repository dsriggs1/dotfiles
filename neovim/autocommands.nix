{
  programs.nixvim.autoCmd = [
    # Vertically center document when entering insert mode
    {
      event = "InsertEnter";
      command = "norm zz";
    }

    # Open help in a vertical split
    {
      event = "FileType";
      pattern = "help";
      command = "wincmd L";
    }

    # Enable spellcheck for some filetypes
    {
      event = "FileType";
      pattern = [
        "tex"
        "latex"
        "markdown"
      ];
      command = "setlocal spell spelllang=en,fr";
    }

    # Auto-yank to PRIMARY selection (*) for middle-click paste
    # When text is yanked in visual mode, also copy to * register
    {
      event = "TextYankPost";
      callback = {
        __raw = ''
          function()
            if vim.v.event.operator == 'y' and vim.v.event.regname == '+' then
              vim.fn.setreg('*', vim.fn.getreg('+'))
            end
          end
        '';
      };
    }
  ];
}
