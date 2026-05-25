{ ... }:
{
  services.openssh = {
    enable = true;
    settings.KbdInteractiveAuthentication = false;
    settings.PasswordAuthentication = false;
  };
}
