{ ... }:
{
  services.openssh = {
    enable = true;
    extraConfig = ''
    PasswordAuthentication no
    KbdInteractiveAuthentication no
    PubkeyAuthentication yes
    '';
  };
}
