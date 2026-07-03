{ secrets, ... }:
{
  fileSystems."/run/media/chris/New Volume" = #E drive
    { device = "/dev/disk/by-uuid/01D7DC1481BB6E80";
      fsType = "ntfs";
    };
    
  fileSystems."/run/media/chris/Basic data partition" = #Windows drive
    { device = "/dev/disk/by-uuid/01DD084173E3D370";
      fsType = "ntfs";
    };
  
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
  
  fileSystems."/".options = [ "compress=zstd:1" "noatime" ];
  fileSystems."/home".options = [ "compress=zstd:1" "noatime" ];
  fileSystems."/nix".options = [ "compress=zstd:1" "noatime" ];
  fileSystems."/var/log".options = [ "compress=zstd:1" "noatime" ];
  fileSystems."/.snapshots".options = [ "compress=zstd:1" "noatime" ];
}
