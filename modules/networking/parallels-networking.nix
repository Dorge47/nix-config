{ secrets, ... }:
{
  networking.nameservers = [
    secrets.parallelsDns
  ];

  services.gvfs.enable = true;

  services.openssh.ports = [ 2222 ];
}
