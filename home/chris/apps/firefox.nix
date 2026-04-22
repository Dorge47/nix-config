{ pkgs, inputs, ... }:
let unstable = import inputs.nixpkgs-unstable {
  system = pkgs.system;
  config = { allowUnfree = true; };
};
in {
  programs.firefox = {
    enable = true;
    package = unstable.firefox-devedition;
  };
}
