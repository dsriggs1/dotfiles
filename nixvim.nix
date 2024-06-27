{ config, pkgs, ...}:

{
  imports = [
    ./options.nix
    ./keymaps.nix
    ./nvim-tree.nix
  ];
programs.nixvim = {
#      options.completeopt = ["menu" "menuone" "noselect"];
     	enable = true; 
      
        globals.mapleader = " ";

     # options = {
      #  number = true;         # Show line numbers
   #   	relativenumber = true; # Show relative line numbers

      #	shiftwidth = 2;        # Tab width should be 2
    # };
    


    # keymaps = [
    #   {
    #     action = "<cmd>Telescope live_grep<CR>";
    #     key = "<leader>g";
    #   }
    #   {
    #     key = "<C-n>";
    #     action = "<CMD>NvimTreeToggle<CR>";
    #     options.desc = "Toggle NvimTree";
    #   }
    #  ]; 
 



       plugins = {
        #nvim-tree = {
         # enable = true;
          #openOnSetupFile = true;
          #autoReloadOnWrite = true;
       # };
        
        codeium-nvim.enable = true;
        treesitter.enable = true;
        
        cmp = {
            enable = true;
            # menu = {
            #   nvim_lsp = "[LSP]";
            #   nvim_lua = "[api]";
            #   path = "[path]";
            #   luasnip = "[snip]";
            #   buffer = "[buffer]";
            #   neorg = "[neorg]";
            #   cmp_tabnine = "[TabNine]";
            # };
          };

        lsp = {
          enable = true;
          
          servers = {
            tsserver.enable = true;
      
            nil-ls ={
              enable = true;
            };

            lua-ls = {
              enable = true;
              settings.telemetry.enable = false;
            };

            rust-analyzer = {
              enable = true;
              installCargo = true;
            };

            pyright = {
              enable = true;
            };
          };  
        };
    };
  };
}
