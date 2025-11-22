{
  description = "My NixOS configuration using flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
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
        modules = [ ./hosts/gustave.nix ];
      };
    };
}

