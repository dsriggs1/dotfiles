{
  programs.nixvim = {
    enable = true;
    plugins.copilot-lua = {
      enable = true;
      settings.suggestion = {
        enabled = false;
      };
    };
  };
}
