{ pkgs, inputs, secrets, ... }:
let unstable = import inputs.nixpkgs-unstable {
  system = pkgs.stdenv.hostPlatform.system;
  config = { allowUnfree = true; };
};
in {
  programs = {
    htop.enable = true;
    yt-dlp.enable = true;
    btop.enable = true;
    tmux.enable = true;
  };
  home.packages = with pkgs; [
    cowsay
    fastfetch
    (fortune.override { withOffensive = true; })
    ncdu
    rclone
    unstable.restic # Need 0.19 for --exclude-cloud-files flag 🙄
    tree
    twitch-cli
  ];
}
