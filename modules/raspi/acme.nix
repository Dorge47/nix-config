{ secrets, ... }:
{
  security.acme = {
    acceptTerms = true;
    defaults.email = secrets.acmeStuff.email;
    certs."${secrets.acmeStuff.mainDomain}" = {
      domain = secrets.acmeStuff.mainDomain;
      extraDomainNames = secrets.domainNames;
      dnsProvider = "cloudflare";
      environmentFile = ./../../secrets/acme-cloudflare.env;
      group = "nginx";
    };
  };
}
