
{
     programs.nixvim = {
          options.completeopt = ["menu" "menuone" "noselect"];

          options = {
          number = true;         # Show line numbers
     #   	relativenumber = true; # Show relative line numbers

               shiftwidth = 2;        # Tab width should be 2
          };
     };
}
