{ ... }:
{
  imports = [
    ./gaming.nix
    ./mounts.nix
    ./packages.nix
    ./security.nix
    ./../../modules/nix
    ./../../modules/boot/prodesk-initrd-unlock.nix
    ./../../modules/boot/grub-prodesk.nix
    ./../../modules/common
    ./../../modules/graphical
    ./../../modules/hardware/bluetooth.nix
    ./../../modules/hardware/graphics.nix
    ./../../modules/networking
    ./../../modules/services/openssh.nix
    ./../../modules/services/printing.nix
    ./../../modules/users/chris-prodesk.nix
  ];
  
  nix.gc.options = "--delete-older-than 30d";
}
