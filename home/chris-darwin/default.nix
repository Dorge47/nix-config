{ ... }:
{
  imports = [
    ./apps
    ./shell/git.nix
    ../common/shell/command-center.nix
    ];

  home.stateVersion = "26.05";
}
