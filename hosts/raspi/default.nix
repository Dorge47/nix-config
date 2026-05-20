{ pkgs, secrets, ... }:
{
  imports = [
    ./hardware-configuration.nix
    #<nixos-hardware/raspberry-pi/4>
    ./../../modules/nix/default.nix
    ./../../modules/boot/raspi-boot.nix
    ./../../modules/networking/default.nix
    ./../../modules/networking/raspi-networking.nix
    ./../../modules/raspi/default.nix
    ./../../modules/services/openssh.nix
    ./../../modules/services/printing.nix
    ./../../modules/users/dorge.nix
  ];
  
  networking.hostName = "nixPi";
  
  # hardware = {
  #   raspberri-pi."4".apply-overlays-dtmerge.enable = true;
  #   deviceTree = {
  #     enable = true;
  #     filter = "*rpi-4-*.dtb";
  #   };
  # };
  
  hardware.enableRedistributableFirmware = true;
}
