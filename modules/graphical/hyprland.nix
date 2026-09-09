{ pkgs, ... }:
{
  programs.hyprland.enable = true;
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
  programs.waybar.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
    wlr.enable = true;
    config.hyprland = {
      default = [
        "hyprland"
        "gtk"
      ];
      "org.freedesktop.impl.portal.Screenshot" = [
        "wlr"
      ];
    };
  };
}
