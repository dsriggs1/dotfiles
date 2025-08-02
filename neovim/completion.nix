{
  programs.nixvim = {
    plugins = {
      luasnip = {
        enable = true;
        settings = {
          fromLua = {
            lazyLoad = false;
            paths = ./snippets;
          };
          enable_autosnippets = true;
          store_selection_keys = "<Tab>";
        };
        luaConfig.content = ''
          require("luasnip.loaders.from_lua").load({ paths = "${./.}/snippets" })
        '';
      };
      copilot-cmp.enable = true;
      #      copilot-lua.enable = true;
      lspkind = {
        enable = true;

        cmp = {
          enable = true;
          menu = {
            nvim_lsp = "[LSP]";
            nvim_lua = "[api]";
            path = "[path]";
            luasnip = "[snip]";
            buffer = "[buffer]";
            neorg = "[neorg]";
            cmp_tabby = "[Tabby]";
            # codeium = "[Codeium]";
            copilot = "[Copilot]";
          };
        };
      };

      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";

          mapping = {
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.close()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";

            # TAB: Try luasnip, then cmp, then fallback
            "<Tab>" = ''
              cmp.mapping(function(fallback)
                local luasnip = require("luasnip")
                if cmp.visible() then
                  cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                  luasnip.expand_or_jump()
                else
                  fallback()
                end
              end, {"i", "s"})
            '';

            # Shift-TAB: jump back in snippet or select previous item
            "<S-Tab>" = ''
              cmp.mapping(function(fallback)
                local luasnip = require("luasnip")
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                  luasnip.jump(-1)
                else
                  fallback()
                end
              end, {"i", "s"})
            '';
          };

          sources = [
            {name = "path";}
            {name = "nvim_lsp";}
            {name = "cmp_tabby";}
            {name = "luasnip";}
            #{name = "codeium";}
            {name = "copilot";}

            {
              name = "buffer";
              # Words from other open buffers can also be suggested.
              option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
            }
            {name = "neorg";}
          ];
        };
      };
    };
  };
}
