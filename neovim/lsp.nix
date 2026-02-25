{
  programs.nixvim = {
    plugins = {
      lsp = {
        enable = true;

        servers = {
          ts_ls.enable = true;

          #          nil-ls = {
          #           enable = true;
          #        };

          nixd = {
            enable = true;
          };

          lua_ls = {
            enable = true;
            settings.telemetry.enable = false;
          };

          #          rust-analyzer = {
          #           enable = true;
          #          installCargo = true;
          #       };

          pyright = {
            enable = true;
          };

          sqls = {
            enable = true;
            extraOptions = {
              settings = {
                sqls = {
                  connections = [
                    {
                      driver = "mysql";
                      dataSourceName = "sean@tcp(127.0.0.1:3306)/retrosheet";
                    }
                  ];
                };
              };
            };
          };

          bashls = {
            enable = true;
          };

          yamlls = {
            enable = true;
          };

          clangd = {
            enable = true;
          };
          #          r-language-server = {
          #           enable = true;
          #        };
        };
      };
    };
  };
}
