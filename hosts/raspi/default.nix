{ pkgs, secrets, ... }:
{
  imports = [
    ./hardware-configuration.nix
    #<nixos-hardware/raspberry-pi/4>
    ./../../modules/boot/raspi-boot.nix
    ./../../modules/networking/default.nix
    ./../../modules/networking/raspi-networking.nix
    ./../../modules/raspi/default.nix
    ./../../modules/services/openssh.nix
  ];
  
  networking.hostName = "nixPi";
}
