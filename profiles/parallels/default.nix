{ pkgs, ... }:
{
  imports = [
    #./mounts.nix
    ./packages.nix
    ./security.nix
    ./../../modules/nix/default.nix
    ./../../modules/boot/parallels-initrd-unlock.nix
    ./../../modules/boot/grub-parallels.nix
    ./../../modules/common
    ./../../modules/graphical/default.nix
    ./../../modules/hardware/bluetooth.nix
    ./../../modules/hardware/peripherals.nix
    ./../../modules/networking/default.nix
    ./../../modules/networking/parallels-networking.nix
    ./../../modules/services/openssh.nix
    ./../../modules/services/printing.nix
    ./../../modules/users/chris-parallels.nix
  ];
  
  nix.gc.options = "--delete-older-than 30d";
  hardware.graphics.enable = true;
}
