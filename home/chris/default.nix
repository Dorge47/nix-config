{ pkgs, inputs, secrets, ... }:
let unstable = import inputs.nixpkgs-unstable {
  system = pkgs.system;
  config = { allowUnfree = true; };
};
in {
  imports = [
    ./hyprland/default.nix
    ./hyprland/settings.nix
    ./hyprland/hyprlock.nix
    ./shell/git.nix
    ./desktop/kitty.nix
    ./apps/vscode.nix
    ./apps/firefox.nix
    ];

  home.stateVersion = "23.11";
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
  };
  home.packages = with pkgs; [
    wget
    (fortune.override { withOffensive = true; })
    neofetch
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
    vdhcoapp
    lutris
    unstable.p7zip-rar
    python315
    (factorio-space-age.override { username = "dorge47"; token = secrets.factorioToken; })
    kdePackages.kate
  ];
  services = {
    mpd = {
      enable = true;
      musicDirectory = secrets.music;
    };
  };
}
