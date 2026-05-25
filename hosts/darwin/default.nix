{ pkgs, ... }:
{
  imports = [
    ./../../modules/darwin/default.nix
  ];
  
  networking.hostName = "Chriss-MacBook-Pro";
}
