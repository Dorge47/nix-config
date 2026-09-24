{ ... }:
{
  imports = [
    ./apps
    ./desktop/kitty.nix
    ./hyprland
    ./shell/git.nix
    ./shell/command-center.nix
    ];

  home.stateVersion = "23.11";
}
