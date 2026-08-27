{ pkgs, inputs, config, ... }:
let unstable = import inputs.nixpkgs-unstable {
  system = pkgs.stdenv.hostPlatform.system;
  config = { allowUnfree = true; };
};
in {
  programs.firefox = {
    enable = true;
    package = unstable.firefox-devedition;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
  };
}
