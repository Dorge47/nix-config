{ pkgs, inputs, secrets, ... }:
let unstable = import inputs.nixpkgs-unstable {
  system = pkgs.stdenv.hostPlatform.system;
  config = { allowUnfree = true; };
};
in {
  imports = [
    ./apps
    ./desktop/kitty.nix
    ./hyprland
    ./shell/git.nix
    ];

  home.stateVersion = "26.05";
}
