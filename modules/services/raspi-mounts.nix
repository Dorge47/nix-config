{ secrets, ... }:
{
  fileSystems."/run/media/dorge/plex" = #Fileserver
    { device = secrets.plexPath;
      fsType = "cifs";
      options = [ "credentials=/home/dorge/Documents/GitHub/nix-config/secrets/raspi-credentials.txt" ];
    };
}
