{ pkgs, inputs, ... }:
{
  imports = [
    ./plasma.nix
    ./hyprland.nix
    ./audio.nix
    ./fonts.nix
    ./display.nix
  ];
  
}
