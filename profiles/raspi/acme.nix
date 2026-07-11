{ secrets, ... }:
{
  security.acme = {
    acceptTerms = true;
    defaults.email = secrets.acmeStuff.email;
    certs."${secrets.acmeStuff.mainDomain}" = {
      domain = secrets.acmeStuff.mainDomain;
      extraDomainNames = secrets.domainNames;
      dnsProvider = "cloudflare";
      environmentFile = "/home/dorge/Documents/GitHub/nix-config/secrets/acme-cloudflare.env";
      group = "nginx";
    };
  };
}
