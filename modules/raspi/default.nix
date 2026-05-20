{ pkgs, ... }:
{
  imports = [
    ./acme.nix
    ./nginx.nix
  ];
  
  # hardware = {
  #   raspberri-pi."4".apply-overlays-dtmerge.enable = true;
  #   deviceTree = {
  #     enable = true;
  #     filter = "*rpi-4-*.dtb";
  #   };
  # };

  time.timeZone = "America/Los_Angeles";
  
  # Select internationalisation properties.
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
  
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  
  console = {
    font = "ter-v32n";
    packages = with pkgs; [ terminus_font ];
  };
  
  programs.git.enable = true;
  programs.htop.enable = true;
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  
  environment.systemPackages = with pkgs; [
    vim
    wget
    libraspberrypi
    raspberrypi-eeprom
    cifs-utils
    btop
    git-crypt
  ];
  
  system.stateVersion = "25.05"; # damn is that a yellow-rumped warbler
  
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gtk2;
    enableSSHSupport = true;
  };
  
  nix.gc.options = "--delete-older-than 180d";
}
