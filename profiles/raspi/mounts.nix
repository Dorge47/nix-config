{ secrets, ... }:
{
  fileSystems."/run/media/dorge/plex" = #Used by jellyfin, not plex. Couldn't be arsed to change the filepath after switching
    { device = secrets.plexPath;
      fsType = "cifs";
      options = [ "credentials=/home/dorge/Documents/GitHub/nix-config/secrets/raspi-credentials.txt" ];
    };
}
