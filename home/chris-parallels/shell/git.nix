{ ... }:
{
  programs.git = {
    enable = true;
    settings.user = {
      name = "Dorge47";
      email = "Dorge47@users.noreply.github.com";
    };
    settings = {
      credential.helper = "store";
    };
  };
}
