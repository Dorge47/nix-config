{ pkgs, ... }:
{
  # GnuPG
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gtk2; # Need something that works on gui and cli
    enableSSHSupport = true;
  };
}
