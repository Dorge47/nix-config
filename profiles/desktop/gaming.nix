{ pkgs, ... }:
{
  # Enable Steam
  programs.steam = {
    enable = true;
    extraPackages = with pkgs; [
      nspr
      nss
    ];
  };
  environment.sessionVariables = {
    DXVK_HUD = "0";
  };
}
