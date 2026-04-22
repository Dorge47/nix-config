{ ... }:
{
  programs.git = {
    enable = true;
    settings.user = {
      name = "Dorge47";
      email = "Dorge47@users.noreply.github.com";
    };
    signing = {
      signByDefault = true;
      key = "71107D53545117FE";
    };
  };
}
