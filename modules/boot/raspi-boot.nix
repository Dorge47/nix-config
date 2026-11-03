{ pkgs, ... }:
{
  boot = {
    loader = {
      # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
      grub.enable = false;
      # Enables the generation of /boot/extlinux/extlinux.conf
      generic-extlinux-compatible.enable = true;
    };
    initrd.availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" ];
    kernelPatches = [
      {
        name = "CVE-2026-98432";
        patch = ../../patches/CVE-2026-98432.patch;
      }
    ];
  };
}
