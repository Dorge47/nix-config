{ secrets, ... }:
{
  fileSystems."/run/media/chris/fileserver" = #Unraid server
    { device = secrets.unraidPath;
      fsType = "cifs";
      options = [
        "credentials=/home/chris/Documents/GitHub/nix-config/secrets/desktop-credentials.txt"
        "uid=1000"
        "gid=100"
        "file_mode=0664"
        "dir_mode=0775"
        "rw"
        "vers=3.1.1"
        "nofail"
        "x-systemd.automount"
      ];
    };
}
