{ pkgs, inputs, secrets, ... }:
let unstable = import inputs.nixpkgs-unstable {
  system = pkgs.stdenv.hostPlatform.system;
  config = { allowUnfree = true; };
};
in {
  imports = [
    ./firefox.nix
    ./vscode.nix
  ];
  programs = {
    vim.enable = true;
    htop.enable = true;
    yt-dlp.enable = true;
    chromium.enable = true;
    fzf.enable = true;
    waybar.enable = true;
    rofi = {
      enable = true;
      theme = "android_notification";
    };
    btop = {
      enable = true;
    };
    tmux.enable = true;
  };
  home.packages = with pkgs; [
    wget
    (fortune.override { withOffensive = true; })
    fastfetch
    vlc
    obsidian
    steamcmd
    gimp
    handbrake
    dbeaver-bin
    prismlauncher
    jdk
    azahar
    ncdu
    pavucontrol
    lutris
    unstable.p7zip-rar
    (python314.withPackages (ps: with ps; [
      pillow
    ]))
    kdePackages.kate
    # dolphin-emu BUILDING FROM SOURCE >:(
    melonds
    qdirstat
    restic
    libreoffice
  ];
}
