{ pkgs, ... }:
{
  home.packages = with pkgs; [
    libnotify
    mpvpaper
    wl-clipboard
    slurp
    grim
    kdePackages.dolphin
    ulauncher
    blueman
    wev
    kdePackages.qt6ct
  ];
  services.mako.enable = true;
  wayland.windowManager.hyprland.enable = true;
}
