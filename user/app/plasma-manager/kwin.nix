{...}: {
  programs.plasma = {
    kwin = {
      effects = {
        blur.enable = false; # replaced by kwin-effects-better-blur-dx (force blur)
        cube.enable = false;
        desktopSwitching.animation = "off";
        dimAdminMode.enable = false;
        dimInactive.enable = false;
        fallApart.enable = false;
        fps.enable = false;
        minimization.animation = "off";
        shakeCursor.enable = false;
        slideBack.enable = false;
        snapHelper.enable = false;
        translucency.enable = true;
        windowOpenClose.animation = "off";
        wobblyWindows.enable = false;
      };
      virtualDesktops = {
        number = 5;
        rows = 1;
      };
    };
  };
}
