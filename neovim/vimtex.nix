{pkgs, ...}: {
  programs.nixvim = {
    plugins = {
      vimtex.enable = true;
      vimtex.texlivePackage = pkgs.texlive.combined.scheme-full;
    };
  };
}
