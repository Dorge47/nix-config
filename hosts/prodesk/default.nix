{ pkgs, secrets, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./../../profiles/prodesk
  ];
  
  networking.hostName = "nixos-prodesk";
  system.stateVersion = "26.05"; #ヤラララ
}
