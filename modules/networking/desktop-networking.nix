{ secrets, ... }:
{
  networking.nameservers = [
    secrets.controlDns # Use the DNS server defined in secrets.nix
  ];
  
  networking.firewall.allowedTCPPorts = [
    25565 # Minecraft
  ];
  
  services.gvfs.enable = true; # smb support
}
