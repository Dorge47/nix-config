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
      key = "901A6D63CEFB76B4";
    };
  };
}
