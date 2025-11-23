{
  description = "My NixOS configuration using flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    vicinae.url = "github:vicinaehq/vicinae";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, vicinae, ... }:
    let system = "x86_64-linux";
    in {
      nixosConfigurations.gustave = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit system;
          inherit inputs;
          pkgs-unstable = import nixpkgs-unstable { inherit system; };
          vicinae-pkg = vicinae.packages.${system}.default;
        };
        modules = [ ./hosts/gustave.nix ];
      };
    };
}

