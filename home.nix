{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./sh.nix
    # ./firefox.nix
    ./user/app/git/git.nix
    ./vscode.nix
    ./neovim/nixvim.nix
  ];

  home.username = "sean";
  home.homeDirectory = "/home/sean";

  #  stylix.image = /home/sean/wallpapers/lake-sunrise.jpg;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";

  home.packages = with pkgs; [
    git
    vscode
    firefox
  ];

  #   programs.nixvim = {
  #     options.completeopt = ["menu" "menuone" "noselect"];
  #    	enable = true;

  #     globals.mapleader = " ";

  #options = {
  #number = true;         # Show line numbers
  #  #   	relativenumber = true; # Show relative line numbers

  #     	shiftwidth = 2;        # Tab width should be 2
  # };

  #      keymaps = [
  #     {
  #       action = "<cmd>Telescope live_grep<CR>";
  #       key = "<leader>g";
  #     }
  #     {
  #       key = "<C-n>";
  #       action = "<CMD>NvimTreeToggle<CR>";
  #       options.desc = "Toggle NvimTree";
  #     }
  #    ];

  #     plugins = {
  #       nvim-tree = {
  #         enable = true;
  #         openOnSetupFile = true;
  #         autoReloadOnWrite = true;
  #       };

  #       codeium-nvim.enable = true;
  #       treesitter.enable = true;

  #       cmp = {
  #           enable = true;
  #           # menu = {
  #           #   nvim_lsp = "[LSP]";
  #           #   nvim_lua = "[api]";
  #           #   path = "[path]";
  #           #   luasnip = "[snip]";
  #           #   buffer = "[buffer]";
  #           #   neorg = "[neorg]";
  #           #   cmp_tabnine = "[TabNine]";
  #           # };
  #         };

  #       lsp = {
  #         enable = true;

  #         servers = {
  #           tsserver.enable = true;

  #           nil-ls ={
  #             enable = true;
  #           };

  #           lua-ls = {
  #             enable = true;
  #             settings.telemetry.enable = false;
  #           };

  #           rust-analyzer = {
  #             enable = true;
  #             installCargo = true;
  #           };

  #           pyright = {
  #             enable = true;
  #           };
  #         };
  #       };
  #   };

  # plugins.nvim-tree = {
  # 	enable = true;
  # };

  # plugins.cmp = {
  #     enable = true;
  #     autoEnableSources = true;
  #       sources = [
  #         {name = "nvim_lsp";}
  #     #   {name = "path";}
  #     #   {name = "buffer";}
  #     #   {name = "luasnip";}
  #      ];
  #   };

  #  plugins.lsp = {
  #     enable = true;

  #     servers = {
  #       tsserver.enable = true;

  #       nil-ls ={
  #         enable = true;
  #       };

  #       lua-ls = {
  #         enable = true;
  #         settings.telemetry.enable = false;
  #       };

  #       rust-analyzer = {
  #         enable = true;
  #         installCargo = true;
  #       };

  #       pyright = {
  #         enable = true;
  #       };
  #     };
  #   };

  # plugins.treesitter = {
  #   enable = true;
  # };

  # plugins.codeium-nvim = {
  #   enable = true;
  # };
  # };

  # programs.vscode = {
  #   enable = true;
  #   extensions = with pkgs.vscode-extensions; [
  #     github.copilot
  #     ms-python.python
  #     jnoortheen.nix-ide
  #   ];

  # };

  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
          ublock-origin
        ];
        bookmarks = {
          toolbar = {
            name = "My Toolbar";
            toolbar = true;

            bookmarks = [
              {
                name = "Nixos Wiki";
                tags = ["nixos"];
                keyword = "nixos";
                url = "https://wiki.nixos.org/wiki/NixOS_Wiki";
              }
              {
                name = "Jellyfin Server";
                tags = ["Jellyfin"];
                keyword = "Jellyfin";
                url = "http://localhost:8096";
              }

              {
                name = "Bazarr";
                tags = ["Bazarr"];
                keyword = "Bazarr";
                url = "http://localhost:6767";
              }

              {
                name = "Lidarr";
                tags = ["Lidarr"];
                keyword = "Lidarr";
                url = "http://localhost:8686";
              }

              {
                name = "Prowlarr";
                tags = ["Prowlarr"];
                keyword = "Prowlarr";
                url = "http://localhost:9696";
              }

              {
                name = "Radarr";
                tags = ["Radarr"];
                keyword = "Radarr";
                url = "http://localhost:7878";
              }

              {
                name = "Sonarr";
                tags = ["Sonarr"];
                keyword = "Sonarr";
                url = "http://localhost:8989";
              }

              {
                name = "github";
                tags = ["github"];
                keyword = "github";
                url = "https://github.com/";
              }
            ];
          };
        };
      };
    };
  };

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
