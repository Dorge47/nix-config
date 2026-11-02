{ ... }:
{
  imports = [
    ./apps
    ./desktop/kitty.nix
    ./hyprland
    ./shell/git.nix
    ../common/shell/command-center.nix
    ];

  home.stateVersion = "23.11";
}
