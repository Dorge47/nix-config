{ ... }:
{
  services.syncthing = {
    enable = true;
    relay.enable = false;
    openDefaultPorts = true;
    user = "chris";
    dataDir = "/home/chris";
    configDir = "/home/chris/.config/syncthing";
  };
}
