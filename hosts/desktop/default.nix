{ pkgs, secrets, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/nix/default.nix
    ./../../modules/boot/desktop-boot.nix
    ./../../modules/boot/grub.nix
    ./../../modules/networking/default.nix
    ./../../modules/networking/desktop-networking.nix
    ./../../modules/desktop/default.nix
    ./../../modules/services/openssh.nix
    ./../../modules/services/syncthing.nix
    ./../../modules/services/desktop-mounts.nix
    ./../../modules/services/printing.nix
    ./../../modules/hardware/bluetooth.nix
    ./../../modules/users/chris.nix
  ];
  
  networking.hostName = "nixos";
}
