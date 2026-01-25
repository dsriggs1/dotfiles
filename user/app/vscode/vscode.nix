{
  config,
  pkgs,
  ...
}: {
  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        github.copilot
        ms-python.python
        jnoortheen.nix-ide
      ];

      userSettings = {
        "security.workspace.trust.enabled" = false;
      };
    };
  };
}
