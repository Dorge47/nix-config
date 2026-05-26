{
  description = "NixOS configuration";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";
    nixpkgs-nixfix.url = "github:NixOS/nixpkgs/master";
  };
  
  outputs = inputs@{ nixpkgs, nix-darwin, home-manager, nixpkgs-nixfix, ... }:
  let secrets = import ./secrets/secrets.nix;
  in {
    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs secrets; };
      modules = [
        ./hosts/desktop/default.nix
        home-manager.nixosModules.default
        {
          home-manager.useGlobalPkgs = true;
          home-manager.extraSpecialArgs = {
            inherit inputs secrets;
          };
        }
      ];
    };
    nixosConfigurations.raspi = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = { inherit inputs secrets; };
      modules = [
        ./hosts/raspi/default.nix
      ];
    };
    darwinConfigurations.macbook = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = { inherit inputs secrets; };
      modules = [
        ./hosts/darwin/default.nix
      ];
    };
  };
}
