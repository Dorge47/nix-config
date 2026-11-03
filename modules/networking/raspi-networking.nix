{ secrets, ... }:
{
  networking.nameservers = [
    secrets.raspiDns
  ];
  
  networking.firewall.allowedTCPPorts = [
    80
    443
    3306
  ];
  networking.firewall.allowedUDPPorts = [
    80
    443
  ];
}
