{ pkgs, inputs, ... }:
let unstable = import inputs.nixpkgs-unstable {
  system = pkgs.system;
  config = { allowUnfree = true; };
};
in {
  programs.vscode = {
    enable = true;
    package = unstable.vscode;
  };
}
