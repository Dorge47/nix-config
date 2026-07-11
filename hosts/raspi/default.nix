{ pkgs, secrets, ... }:
{
  imports = [
    ./hardware-configuration.nix
    #<nixos-hardware/raspberry-pi/4>
    ./../../profiles/raspi
  ];
  
  networking.hostName = "nixPi";
  system.stateVersion = "25.05"; # damn is that a yellow-rumped warbler
  
  # hardware = {
  #   raspberri-pi."4".apply-overlays-dtmerge.enable = true;
  #   deviceTree = {
  #     enable = true;
  #     filter = "*rpi-4-*.dtb";
  #   };
  # };
  
  hardware.enableRedistributableFirmware = true;
}
