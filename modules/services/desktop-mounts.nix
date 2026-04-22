{ secrets, ... }:
{
  fileSystems."/run/media/chris/New Volume" = #E drive
    { device = "/dev/disk/by-uuid/01D7DC1481BB6E80";
      fsType = "ntfs";
    };
    
  fileSystems."/run/media/chris/Basic data partition" = #Windows drive
    { device = "/dev/disk/by-uuid/01D9D96304239210";
      fsType = "ntfs";
    };
  
  fileSystems."/run/media/chris/fileserver" = #Unraid server
    { device = secrets.unraid.path;
      fsType = "cifs";
      options = secrets.unraid.options;
    };
}
