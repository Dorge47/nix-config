{
  description = "NixOS configuration";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-nixfix.url = "github:NixOS/nixpkgs/86a3458";
  };
  
  outputs = inputs@{ nixpkgs, home-manager, nixpkgs-nixfix, ... }:
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
  };
}
