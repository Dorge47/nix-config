{ pkgs, ... }:
{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gnupg
    nodejs
    hwinfo
    pciutils
    kdePackages.filelight
    openvpn
    kmymoney
    obs-studio
    cifs-utils
    protonup-qt
    libinput
    mimalloc
    coolercontrol.coolercontrol-gui
    coolercontrol.coolercontrold
    coolercontrol.coolercontrol-ui-data
    lm_sensors
    gparted
    git-crypt
  ];
}
