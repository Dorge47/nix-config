{ pkgs, ... }:
{
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    useOSProber = true;
    device = "nodev";
    default = "saved";
    extraEntries = "GRUB_SAVEDEFAULT=true";
    theme = pkgs.stdenv.mkDerivation {
      pname = "minegrub-theme";
      version = "master";
      src = pkgs.fetchFromGitHub {
        owner = "Dorge47";
        repo = "minegrub-theme";
        rev = "7e4d22350e981dfe1fb25073c321c9f8df050707";
        hash = "sha256-xUjeDb3+NUD6XTJvOua623IH5FyMcMYBXT7SRuznAXY=";
      };
      installPhase = ''
      mkdir -p $out
      cp -r minegrub/* $out/'';
    };
  };
}
