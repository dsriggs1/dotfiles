{
  description = "NixOS configuration for my personal laptop";

  inputs = {
    # NixOS official package source, using the nixos-23.11 branch here
    #nixpkgs.url = "github:NixOS/nixpkgs/01885a071465";
    # nixpkgs.url = "github:NixOS/nixpkgs/master";
    nixpkgs.url = "github:NixOS/nixpkgs/release-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    stylix.url = "github:danth/stylix/release-23.11";  
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixarr= {
      url = "github:rasmus-kirk/nixarr";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    nur,
    home-manager, 
    firefox-addons,
    nixarr,
    stylix,
    ... 
  } @inputs: 
  let 
    inherit (self) outputs;
    system = "x86_64-linux";
    pkgs = import nixpkgs { system = "x86_64-linux"; config = { allowUnfree = true;  }; };    #addon-pkgs = pkgs.callPackage firefox-addons { };

  in {
    # Please replace my-nixos with your hostname
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          pkgs-unstable = import nixpkgs-unstable {
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

          inherit pkgs inputs ;      
      };  
        modules = [
          # Import the previous configuration.nix we used,
          # so the old configuration file still takes effect
            ./configuration.nix
          #./nixos/servarr/configuration.nix
            nixarr.nixosModules.default
            stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.sean = import ./home.nix {
              inherit pkgs inputs ;
              config = pkgs.config;
             };
          }
        ];
      };
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
