{ pkgs, ... }:
{
  services.desktopManager.plasma6.enable = true;
  systemd.user.services.waybar.unitConfig = {
    ConditionEnvironment = "XDG_CURRENT_DESKTOP=Hyprland"; # Don't start waybar on Plasma >:(
  };
  
  environment.etc = {
    # https://github.com/NixOS/nixpkgs/issues/409986#issuecomment-3217982330
    "xdg/menus/applications.menu".source = "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
  };
}
