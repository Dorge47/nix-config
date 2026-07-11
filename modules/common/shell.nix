{ pkgs, ... }:
{
  # Enable fish shell as default
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
    set -g fish_greeting
    fortune -s'';
  };
  users.defaultUserShell = pkgs.fish;
}
