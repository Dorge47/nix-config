{ pkgs, secrets, ... }:
{
  imports = [
    ./hardware-configuration.nix
    #<nixos-hardware/raspberry-pi/4>
    ./../../profiles/raspi
  ];
  
  networking.hostName = "nixPi";
  system.stateVersion = "26.05"; # Can't you see the stone right at your feet?
  
  # hardware = {
  #   raspberri-pi."4".apply-overlays-dtmerge.enable = true;
  #   deviceTree = {
  #     enable = true;
  #     filter = "*rpi-4-*.dtb";
  #   };
  # };
  
  hardware.enableRedistributableFirmware = true;
}
