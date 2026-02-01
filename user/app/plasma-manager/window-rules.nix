{...}: {
  programs.plasma = {
    enable = true;
    window-rules = [
      {
        description = "Alacritty active opacity 70%";

        match = {
          window-class = {
            value = "alacritty";
            type = "substring";
            match-whole = true;
          };
        };

        apply = {
          opacityactive = {
            value = 70;
            apply = "force"; # or "initially" if you only want it set on startup
          };
        };
      }
      {
        description = "Hide titlebar for Alacritty";
        match = {
          window-class = {
            value = "alacritty";
            type = "substring";
            match-whole = true;
          };
        };
        apply = {
          noborder = {
            value = true;
            apply = "force";
          };
        };
      }
      {
        description = "Rstudio active opacity 70%";

        match = {
          window-class = {
            value = "rstudio";
            type = "substring";
            match-whole = true;
          };
        };

        apply = {
          opacityactive = {
            value = 70;
            apply = "force"; # or "initially" if you only want it set on startup
          };
        };
      }
      {
        description = "Dolphin active opacity 70%";
        match = {
          window-class = {
            value = "dolphin";
            type = "substring";
            match-whole = true;
          };
        };
        apply = {
          opacityactive = {
            value = 70;
            apply = "force";
          };
        };
      }
      {
        description = "Assign Firefox to Desktop 2";
        match = {
          window-class = {
            # match = {
            value = "firefox";
            type = "substring";
            match-whole = true;
          };
        };
        apply = {
          desktops = "Desktop_2";
          desktopsrule = "3";
        }; # apply = "initially";
      } # };
    ];
  };
}
