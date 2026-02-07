{...}: {
  programs.plasma = {
    enable = true;
    window-rules = [
      {
        description = "Disable transparency for Gwenview";
        match = {
          window-class = {
            value = "gwenview";
            type = "substring";
            match-whole = false;
          };
        };
        apply = {
          opacityactive = {
            value = 100;
            apply = "force";
          };
          opacityinactive = {
            value = 100;
            apply = "force";
          };
        };
      }
      {
        description = "All windows active opacity 70%";

        match = {};

        apply = {
          opacityactive = {
            value = 70;
            apply = "force";
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
