{ ... }:
{
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0" # Required for Obsidian
    "mbedtls-2.28.10" # Required for OpenRGB
  ];
  
}
