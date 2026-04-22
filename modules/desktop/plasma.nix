{ ... }:
{
  services.desktopManager.plasma6.enable = true;
  systemd.user.services.waybar.unitConfig = {
    ConditionEnvironment = "XDG_CURRENT_DESKTOP=Hyprland"; # Don't start waybar on Plasma >:(
  };
}
