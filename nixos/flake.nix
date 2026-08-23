{
  description = "My NixOS configuration using flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    vicinae.url = "github:vicinaehq/vicinae";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, vicinae, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations.gustave = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit system inputs pkgs-unstable;
        };
        modules = [
          ./hosts/gustave.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.chris = import ./home;
            home-manager.extraSpecialArgs = {
              inherit inputs pkgs-unstable;
            };
            home-manager.sharedModules = [
              vicinae.homeManagerModules.default
            ];
          }
        ];
      };
    };
}

