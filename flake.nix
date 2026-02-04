{
  description = "NixOS configuration for my personal laptop";

  inputs = {
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/release-25.11";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #    impermanence = {
    #     url = "github:nix-community/impermanence";
    #   };

    # nur.url = "github:nix-community/NUR";
    stylix.url = "github:danth/stylix/release-25.11";
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #nixarr = {
    #url = "github:rasmus-kirk/nixarr";
    #inputs.nixpkgs.follows = "nixpkgs";
    #};
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    kwin-effects-better-blur-dx = {
      url = "github:xarblu/kwin-effects-better-blur-dx";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    #nur,
    home-manager,
    firefox-addons,
    #nixarr,
    stylix,
    nixvim,
    disko,
    plasma-manager,
    ...
  } @ inputs: let
    systemSettings = {
      system = "x86_64-linux";
      timezone = "America/New_York";
      hostname = "nixos"; # hostname
      profile = "personal"; # select a profile defined from my profiles directory
      locale = "en_US.UTF-8"; # select locale
    };

    userSettings = {
      username = "sean"; # username
      name = "Sean"; # name/identifier
      email = "dsriggs1@gmail.com"; # email (used for certain configurations)
      dotfilesDir = "~/.dotfiles"; # absolute path of the local repo
      #theme = "io"; # selcted theme from my themes directory (./themes/)
      #wm = "hyprland"; # Selected window manager or desktop environment; must select one in both ./user/wm/ and ./system/wm/
      # window manager type (hyprland or x11) translator
      #wmType =
      # if ((wm == "hyprland") || (wm == "plasma"))
      #then "wayland"
      #else "x11";
      # browser = "qutebrowser"; # Default browser; must select one from ./user/app/browser/
      term = "alacritty"; # Default terminal command;
      #font = "Intel One Mono"; # Selected font
      #fontPkg = pkgs.intel-one-mono; # Font package
      #editor = "neovide"; # Default editor;
      homeDir = "/home/sean";
    };

    # Define pkgs-stable once for reuse
    pkgs-stable = import nixpkgs {
      system = systemSettings.system;
      config.allowUnfree = true;
    };
  in {
    #apps.x86_64-linux = {
    # disko = disko.defaultApp.x86_64-linux;
    # };
    nixosConfigurations.${systemSettings.hostname} = nixpkgs.lib.nixosSystem {
      system = systemSettings.system;
      specialArgs = {
        inherit systemSettings pkgs-stable inputs;
        #nur = import nur {
        #system = systemSettings.system;
        #config.allowUnfree = true;
        #};
        #nixarr = import nixarr {
        #system = systemSettings.system;
        #config.allowUnfree = true;
        #};
      };
      modules = [
        #    ./disko-config.nix
        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        ./configuration.nix
        #./nixos/servarr/configuration.nix
        inputs.disko.nixosModules.disko
        #nixarr.nixosModules.default
        stylix.nixosModules.stylix
        # inputs.impermanence.nixosModules.impermanence
        home-manager.nixosModules.home-manager
        #   (import ./disko-config.nix {device = "/dev/vda";})
        {
          #   home-manager.extraSpecialArgs = specialArgs;

          home-manager.extraSpecialArgs = {
            inherit inputs userSettings pkgs-stable;
          };

          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.sharedModules = [
            nixvim.homeModules.nixvim
            inputs.plasma-manager.homeManagerModules.plasma-manager
            # inputs.impermanence.homeManagerModules.impermanence
          ];
          home-manager.users.${userSettings.username} = import ./home.nix;
        }
      ];
    };
  };
}
