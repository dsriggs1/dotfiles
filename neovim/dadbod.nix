{pkgs, ...}: let
  # Create a mysql wrapper that suppresses deprecation warnings
  mysql-quiet = pkgs.writeShellScriptBin "mysql" ''
    ${pkgs.mariadb}/bin/mysql "$@" 2> >(grep -v "Deprecated program name" >&2)
  '';
in {
  programs.nixvim = {
    plugins.vim-dadbod = {
      enable = true;
    };

    # Add vim-dadbod-ui and completion
    extraPlugins = with pkgs.vimPlugins; [
      vim-dadbod-ui
      vim-dadbod-completion
    ];

    # Add mysql wrapper that suppresses deprecation warnings
    extraPackages = [
      mysql-quiet
      pkgs.mariadb
    ];

    # Configure dadbod-ui
    extraConfigLua = ''
      -- Auto-execute queries and show results
      vim.g.db_ui_auto_execute_table_helpers = 1
      vim.g.db_ui_save_location = vim.fn.stdpath('data') .. '/dadbod_ui'
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_execute_on_save = 0

      -- Enable vim-dadbod-completion for SQL files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {"sql", "mysql", "plsql"},
        callback = function()
          local cmp = require('cmp')
          -- Get current sources and prepend vim-dadbod-completion
          local sources = cmp.get_config().sources
          local new_sources = vim.deepcopy(sources)

          -- Add vim-dadbod-completion at the beginning
          table.insert(new_sources, 1, { name = 'vim-dadbod-completion' })

          cmp.setup.buffer({ sources = new_sources })
        end,
      })

      -- Disable folding in .dbout result files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "dbout",
        callback = function()
          vim.opt_local.foldenable = false
        end,
      })

      -- Also disable folding when opening .dbout files
      vim.api.nvim_create_autocmd("BufRead", {
        pattern = "*.dbout",
        callback = function()
          vim.opt_local.foldenable = false
        end,
      })

      -- Autocmd to auto-open query results
      vim.api.nvim_create_autocmd("User", {
        pattern = "DBQueryPost",
        callback = function()
          vim.defer_fn(function()
            local buffers = vim.api.nvim_list_bufs()
            for _, buf in ipairs(buffers) do
              local bufname = vim.api.nvim_buf_get_name(buf)
              if bufname:match('%.dbout$') and vim.api.nvim_buf_is_loaded(buf) then
                local wins = vim.fn.win_findbuf(buf)
                if #wins == 0 then
                  vim.cmd('split')
                  vim.api.nvim_set_current_buf(buf)
                end
                break
              end
            end
          end, 100)
        end,
      })
    '';

    # Keybindings
    keymaps = [
      {
        mode = "n";
        key = "<leader>db";
        action = "<cmd>DBUI<cr>";
        options.desc = "Open database UI";
      }
      {
        mode = "v";
        key = "<leader>S";
        action = ":DB<cr>";
        options.desc = "Execute selected SQL query and show results";
      }
      {
        mode = "n";
        key = "<leader>S";
        action = ":.DB<cr>";
        options.desc = "Execute SQL query on current line and show results";
      }
      {
        mode = "n";
        key = "<leader>so";
        action = "<cmd>DBUILastQueryInfo<cr>";
        options.desc = "Open last query result";
      }
    ];
  };
}
