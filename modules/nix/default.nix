{ ... }:
{
  imports = [
    ./settings.nix
    ./insecure-packages.nix
  ];

  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];
}
