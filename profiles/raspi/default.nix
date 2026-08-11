{ pkgs, ... }:
{
  imports = [
    ./acme.nix
    ./mounts.nix
    ./nginx.nix
    ./../../modules/nix/default.nix
    ./../../modules/boot/raspi-boot.nix
    ./../../modules/common
    ./../../modules/networking/default.nix
    ./../../modules/networking/raspi-networking.nix
    ./../../modules/services/openssh.nix
    ./../../modules/services/printing.nix
    ./../../modules/users/dorge.nix
  ];
  
  # hardware = {
  #   raspberri-pi."4".apply-overlays-dtmerge.enable = true;
  #   deviceTree = {
  #     enable = true;
  #     filter = "*rpi-4-*.dtb";
  #   };
  # };
  
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  
  console = {
    font = "ter-v32n";
    packages = with pkgs; [ terminus_font ];
  };
  
  programs.git = {
    enable = true;
    config.credential.helper = "store";
  };
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
    yt-dlp
    ncdu
    restic
    rclone
    (fortune.override { withOffensive = true; })
  ];
  
  nix.gc.options = "--delete-older-than 180d";
}
