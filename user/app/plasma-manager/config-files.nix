{...}: {
  programs.plasma = {
    enable = true;
    configFile = {
      "baloofilerc"."Basic Settings"."Indexing-Enabled" = false;
      "kwinrc"."org.kde.kdecoration2"."ButtonsOnLeft" = "SF";
      "kwinrc"."Desktops"."Number" = {
        value = 5;
        # Forces kde to not change this value (even through the settings app).
        immutable = true;
      };
      kwinrc = {
        Effect-overview.BorderActivate = 9;
        Plugins = {
          krohnkiteEnabled = true;
          shapecornersEnabled = true;
          better_blur_dxEnabled = true;
        };
        "Effect-better-blur-dx" = {
          BlurStrength = 5;
          NoiseStrength = 8;
          # Force blur behind these window classes (matches window-rules opacity targets)
          WindowClasses = "alacritty\ndolphin\nrstudio";
          BlurMatching = true; # blur the listed classes
          BlurNonMatching = false; # don't force blur on everything else
          BlurDecorations = true; # blur behind window decorations/borders too
        };
        "Round-Corners" = {
          ActiveOutlineAlpha = 255;
          ActiveOutlineUseCustom = false;
          ActiveOutlineUsePalette = true;
          ActiveSecondOutlineUseCustom = false;
          ActiveSecondOutlineUsePalette = true;
          DisableOutlineTile = false;
          DisableRoundTile = false;
          InactiveCornerRadius = 8;
          InactiveOutlineAlpha = 128;
          InactiveOutlineUseCustom = false;
          InactiveOutlineUsePalette = true;
          InactiveSecondOutlineAlpha = 0;
          InactiveSecondOutlineThickness = 0;
          OutlineThickness = 3;
          SecondOutlineThickness = 1;
          Size = 8;
        };
        "Script-krohnkite" = {
          screenGapBetween = 3;
          screenGapBottom = 3;
          screenGapLeft = 3;
          screenGapRight = 3;
          screenGapTop = 3;
        };
      };
    };
  };
}
