{
  programs.nixvim = {
    enable = true;
    plugins.copilot-lua = {
      enable = true;
      suggestion = {
        enabled = false;
      };
    };
  };
}
