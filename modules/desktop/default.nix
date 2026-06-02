{ pkgs, inputs, ... }:
let nixfixPkgs = import inputs.nixpkgs-nixfix {
  system = pkgs.stdenv.hostPlatform.system;
};
in {
  imports = [
    ./plasma.nix
    ./hyprland.nix
    ./audio.nix
    ./fonts.nix
  ];
  
  services.gnome.gnome-keyring.enable = true;
  
  time.timeZone = "America/Los_Angeles";
  time.hardwareClockInLocalTime = true;

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  
  services.displayManager.sddm.enable = true;
  
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  
  # Enable fish shell as default
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  
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
  
  system.stateVersion = "23.11"; # What sound does a tapir make again? Uuuuuuuuuu.
  
  # Enable Steam
  programs.steam.enable = true;
  
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  
  #Enable openrgb
  services.hardware.openrgb.enable = true;
  
  services.openssh.ports = [ 2222 ];
  
  # Wireshark
  programs.wireshark = {
    enable = true;
    dumpcap.enable = true;
    usbmon.enable = true;
    package = pkgs.wireshark;
  };
  
  # GnuPG
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gtk2; # Need something that works on gui and cli
    enableSSHSupport = true;
  };
  
  environment.etc = {
    # Fix stupid high-resolution scrolling on G502
    "libinput/local-overrides.quirks".text = ''
 [Logitech G502]
 MatchName=Logitech G502
 AttrEventCode=-REL_WHEEL_HI_RES;-REL_HWHEEL_HI_RES;'';
    # https://github.com/NixOS/nixpkgs/issues/409986#issuecomment-3217982330
    "xdg/menus/applications.menu".source = "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
  };
  
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0" # Required for Obsidian
    "mbedtls-2.28.10" # Required for OpenRGB
  ];
  
  nix.gc.options = "--delete-older-than 30d";
}
