{ ... }:
{
  # Enable Steam
  programs.steam.enable = true;
  environment.sessionVariables = {
    DXVK_HUD = "0";
  };
}
