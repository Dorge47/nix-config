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
      key = "53829EB396640E87";
    };
    settings = {
      credential.helper = "store";
    };
  };
}
