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
    yazi.enable = true; # testing before I switch hyprland to this
    btop = {
      enable = true;
      package = pkgs.btop-rocm;
    };
    ncmpcpp.enable = true;
    tmux.enable = true;
    codex = {
      enable = true;
      package = unstable.codex;
    };
  };
  home.packages = with pkgs; [
    wget
    (fortune.override { withOffensive = true; })
    fastfetch
    telegram-desktop
    discord
    vlc
    obsidian
    twitch-cli
    steamcmd
    gimp
    handbrake
    dbeaver-bin
    prismlauncher
    jdk
    azahar
    ncdu
    zoom-us
    kdePackages.kdenlive
    pavucontrol
    lutris
    unstable.p7zip-rar
    (python314.withPackages (ps: with ps; [ # Need PIL for minegrub
      pillow#dear
    ]))
    (factorio-space-age.override { username = "dorge47"; token = secrets.factorioToken; })
    kdePackages.kate
    dolphin-emu
    melonds
    proton-authenticator
    qdirstat
    restic
    libreoffice
    rclone
    ncdu
  ];
  services = {
    mpd = {
      enable = true;
      musicDirectory = secrets.music;
    };
  };
}
