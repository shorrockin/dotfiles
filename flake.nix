{
  description = "My NixOS configuration using flakes";

  inputs = {
    # this can be stable, but if it is do not make hyprpanel follow it
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, ... }:
    let system = "x86_64-linux";
    in {
      nixosConfigurations.gustave = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit system;
          inherit inputs;
          pkgs-unstable = import nixpkgs-unstable { inherit system; };
        };
        modules = [
          { nixpkgs.overlays = [ inputs.hyprpanel.overlay ]; }
          ./hosts/gustave.nix
        ];
      };
    };
}

