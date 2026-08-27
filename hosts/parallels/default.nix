{ pkgs, secrets, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./../../profiles/parallels
  ];
  
  networking.hostName = "parallels";
  system.stateVersion = "23.11"; # TAPE-eer? TAP-eer? Nimi!
}
