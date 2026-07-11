{ ... }:
{
  imports = [
    ./gaming.nix
    ./mounts.nix
    ./packages.nix
    ./security.nix
    ./syncthing.nix
    ./../../modules/nix/default.nix
    ./../../modules/boot/desktop-initrd-unlock.nix
    ./../../modules/boot/grub.nix
    ./../../modules/common
    ./../../modules/graphical/default.nix
    ./../../modules/hardware/bluetooth.nix
    ./../../modules/hardware/graphics.nix
    ./../../modules/hardware/openrgb.nix
    ./../../modules/hardware/peripherals.nix
    ./../../modules/networking/default.nix
    ./../../modules/networking/desktop-networking.nix
    ./../../modules/services/openssh.nix
    ./../../modules/services/printing.nix
    ./../../modules/users/chris.nix
  ];
  
  nix.gc.options = "--delete-older-than 30d";
}
