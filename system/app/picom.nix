{...}: {
  services.picom = {
    enable = true;
    fade = true;
    inactiveOpacity = 0.7;
    activeOpacity = 1;
    backend = "glx";
    settings = {
      blur = {
        method = "gaussian";
        size = 10;
        deviation = 10.0;
      };
      #blur-background-fixed = true;
      opacity-rule = [
        #  "70:class_g = 'Alacritty'"
      ];
    };
  };
}
