{ ... }:
{
  imports = [
    ./settings.nix
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0" # Required for Obsidian
    "mbedtls-2.28.10" # Required for OpenRGB
  ];

  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "nixos-config=/home/chris/Documents/GitHub/nix-config/configuration.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];
}
