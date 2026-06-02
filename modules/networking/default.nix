{ ... }:
{
  # Enable networking
  networking.networkmanager.enable = true;

  # systemd-resolved
  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSSEC = "true";
      Domains = [ "~." ]; # "use as default interface for all requests"
      # (see man resolved.conf)
      # let Avahi handle mDNS publication
      DNSOverTLS = "opportunistic";
      LLMNR = "true";
      MulticastDNS = "resolve";
    };
  };
}
