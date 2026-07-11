{ pkgs, secrets, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./../../profiles/desktop
  ];
  
  networking.hostName = "nixos";
  system.stateVersion = "23.11"; # What sound does a tapir make again? Uuuuuuuuuu.
}
