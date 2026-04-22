{ pkgs, ... }:
{
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    useOSProber = true;
    device = "nodev";
    theme = pkgs.stdenv.mkDerivation {
      pname = "minegrub-theme";
      version = "master";
      src = pkgs.fetchFromGitHub {
        owner = "Dorge47";
        repo = "minegrub-theme";
        rev = "master";
        hash = "sha256-ZlKa/DLAvQ8z20Xi5qHJjuNq64EJEoYDqgjwpWUz5LA=";
      };
      installPhase = ''
      mkdir -p $out
      cp -r minegrub/* $out/'';
    };
  };
}
