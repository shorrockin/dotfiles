{
  description = "My NixOS configuration using flakes";

  inputs = {
    # this can be stable, but if it is do not make hyprpanel follow it
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let system = "x86_64-linux";
    in {
      nixosConfigurations.gustave = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit system;
          inherit inputs;
        };
        modules = [
          home-manager.nixosModules.home-manager
          { nixpkgs.overlays = [ inputs.hyprpanel.overlay ]; }
          ./hosts/gustave.nix
        ];
      };
    };
}

