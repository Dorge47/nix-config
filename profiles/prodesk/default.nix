{ pkgs, ... }:
let
  picotoolUdevRules = pkgs.runCommand "picotool-udev-rules" { } ''
    mkdir -p $out/lib/udev/rules.d
    cp ${./../../60-picotool.rules} \
      $out/lib/udev/rules.d/60-picotool.rules
  '';
in
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
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      libusb1
      stdenv.cc.cc.lib
    ];
  };
  services.udev.packages = [
    picotoolUdevRules
  ];
}
