{
  description = "NixOS configuration";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nixpkgs-unstable-darwin.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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
        ({ config, pkgs, ... }: {
          boot.kernelPackages = pkgs.linuxPackagesFor (
            pkgs.callPackage
              "${inputs.nixos-hardware}/raspberry-pi/common/kernel.nix"
              {
                rpiVersion = 4;
                argsOverride.kernelPatches = [
                  # https://github.com/NixOS/nixos-hardware/blob/04c6b94fa104bc23650983a4513aea196794d321/raspberry-pi/common/kernel.nix#L48
                  pkgs.kernelPatches.bridge_stp_helper
                  pkgs.kernelPatches.request_key_helper
                ] ++ config.boot.kernelPatches;
              }
          );
        })
      ];
    };
    darwinConfigurations.macbook = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = { inherit inputs secrets; };
      modules = [
        ./hosts/darwin/default.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.extraSpecialArgs = {
            inherit inputs secrets;
          };
        }
      ];
    };
  };
}
