{
  description = "NixOS configuration for my personal laptop";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko = {
      url = "github:nix-community/disko";
      inputs.disko.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };

    nixpkgs-stable.url = "github:NixOS/nixpkgs/release-24.05";
    nur.url = "github:nix-community/NUR";
    stylix.url = "github:danth/stylix/release-23.11";
    nixvim = {
      url = "github:nix-community/nixvim/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixarr = {
      url = "github:rasmus-kirk/nixarr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    nur,
    home-manager,
    firefox-addons,
    nixarr,
    stylix,
    nixvim,
    disko,
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

    pkgs = import nixpkgs {
      system = "x86_64-linux";
      config = {allowUnfree = true;};
    }; #addon-pkgs = pkgs.callPackage firefox-addons { };
  in {
    #apps.x86_64-linux = {
    # disko = disko.defaultApp.x86_64-linux;
    # };
    # Please replace my-nixos with your hostname
    nixosConfigurations.${systemSettings.hostname} = nixpkgs.lib.nixosSystem rec {
      #inherit systemSettings.system;
      system = "x86_64-linux";
      specialArgs = {
        inherit systemSettings;
        pkgs-stable = import nixpkgs-stable {
          system = system;
          config.allowUnfree = true;
        };

        nur = import nur {
          system = system;
          config.allowUnfree = true;
        };
        firefox-addons = import firefox-addons {
          system = system;
          config.allowUnfree = true;
        };
        nixarr = import nixarr {
          system = system;
          config.allowUnfree = true;
        };
        stylix = import stylix {
          system = system;
          config.allowUnfree = true;
        };
        nixvim = import nixvim {
          system = system;
          config.allowUnfree = true;
        };

        inherit pkgs inputs;
      };
      modules = [
        #    ./disko-config.nix
        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        ./configuration.nix
        #./nixos/servarr/configuration.nix
        inputs.disko.nixosModules.disko
        nixarr.nixosModules.default
        stylix.nixosModules.stylix
        inputs.impermanence.nixosModules.impermanence
        home-manager.nixosModules.home-manager
        #   (import ./disko-config.nix {device = "/dev/vda";})
        {
          #   home-manager.extraSpecialArgs = specialArgs;

          home-manager.extraSpecialArgs = {
            inherit inputs;
            inherit userSettings;
            pkgs-stable = import nixpkgs-stable {
              system = system;
              config.allowUnfree = true;
            };
          };

          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.sharedModules = [
            nixvim.homeManagerModules.nixvim
            # inputs.impermanence.homeManagerModules.impermanence
          ];
          home-manager.users.sean = import ./home.nix {
            inherit pkgs;
            inherit userSettings;
            pkgs-stable = import nixpkgs-stable {
              system = system;
              config.allowUnfree = true;
            };

            config = pkgs.config;
            stylix.targets.xyz.enable = false;
          };
        }
      ];
    };

    # homeConfigurations = {
    #   "sean@nixos" = home-manager.lib.homeManagerConfiguration {
    #     pkgs = nixpkgs.legacyPackages.x86_64-linux;
    #     extraSpecialArgs = {inherit inputs outputs;};
    #     modules = [
    #       ./home.nix
    #     ];
    #   };
    # };
    # homeConfigurations."sean@nixos" = home-manager.lib.homeManagerConfiguration {
    #   inherit pkgs;
    #   extraSpecialArgs = { inherit inputs; };
    #   modules = [ ./home.nix ];
    # };
  };
}
