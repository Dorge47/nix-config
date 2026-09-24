{ pkgs, inputs, ... }:
let unstable = import inputs.nixpkgs-unstable {
  system = pkgs.stdenv.hostPlatform.system;
  config = { allowUnfree = true; };
};
in {
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gnupg
    openvpn
    obs-studio
    cifs-utils
    libinput
    gparted
    git-crypt
  ];
}
