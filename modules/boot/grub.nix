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
        rev = "3cb79f6fd80ce07091e7457ce258d72f13b5f5b2";
        hash = "sha256-SYBPlfNARYYT4e/g/AxzOGy7z7zVINrfmz1ov+huQgU=";
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
