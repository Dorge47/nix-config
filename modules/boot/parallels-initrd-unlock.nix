{ pkgs, ... }:
{
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [
    "usbhid"
    "r8152"
    "r8169"
    "mt7925e"
  ];
}
