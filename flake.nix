{
  description = "NixOS configuration";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };
  
  outputs = inputs@{ nixpkgs, nix-darwin, home-manager, ... }:
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
    nixosConfigurations.prodesk = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs secrets; };
      modules = [
        ./hosts/prodesk/default.nix
        home-manager.nixosModules.default
        {
          home-manager.useGlobalPkgs = true;
          home-manager.extraSpecialArgs = {
            inherit inputs secrets;
          };
        }
      ];
    };
    nixosConfigurations.parallels = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = { inherit inputs secrets; };
      modules = [
        ./hosts/parallels/default.nix
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
        inputs.nixos-hardware.nixosModules.raspberry-pi-4
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
