{ pkgs, ... }:
{
  imports = [
    ./hyprlock.nix
    ./settings.nix
  ];
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
    hyprshot
    hyprpolkitagent
  ];
  services.mako.enable = true;
  wayland.windowManager.hyprland.enable = true;
}
