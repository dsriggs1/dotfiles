{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (pkgs.texlive.combine {
      inherit (pkgs.texlive) enumitem;
      # Add other packages as needed
      # inherit (pkgs.texlive) xcolor geometry;
    })
  ];
}
