{ pkgs, ... }:
{
  imports = [
    ./hyprlock.nix
    ./settings.nix
  ];
  home.packages = with pkgs; [
    libnotify
    wl-clipboard
    slurp
    grim
    kdePackages.dolphin
    ulauncher
    blueman
    wev
    kdePackages.qt6ct
  ];
  programs = {
    mpvpaper.enable = true;
    hyprshot.enable = true;
  };
  services = {
    mako.enable = true;
    hyprpolkitagent.enable = true;
  };
  wayland.windowManager.hyprland.enable = true;
}
