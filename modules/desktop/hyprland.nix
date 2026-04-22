{ pkgs, ... }:
{
  programs.hyprland.enable = true;
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
  programs.waybar.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-hyprland
    pkgs.xdg-desktop-portal-gtk
  ];
}
