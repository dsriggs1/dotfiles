{
  programs.nixvim = {
plugins = {
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


