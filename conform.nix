{
  programs.nixvim = {
  plugins.conform-nvim = {
    enable = true;
    notifyOnError = true;
    formattersByFt = {
      java = ["google-java-format"];
      python = ["black"];
      lua = ["stylua"];
      nix = ["alejandra"];
      rust = ["rustfmt"];
    };
  }; 
  };
}
