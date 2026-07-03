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
        hash = "sha256-6cFT+gGHQ2wpFEQlVAtgXrLkUz55+yt91Duedxjeh5Y=";
      };
      installPhase = ''
      mkdir -p $out
      cp -r minegrub/* $out/'';
    };
    extraEntries = ''
    menuentry "Windows Boot Manager" {
      insmod part_gpt
      insmod fat
      insmod search_fs_uuid
      insmod chain
      search --no-floppy --fs-uuid --set=root 368B-7AF0
      chainloader /EFI/Microsoft/Boot/bootmgfw.efi
    }
    '';
  };
}
