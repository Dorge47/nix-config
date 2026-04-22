{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    noto-fonts-cjk-serif
    noto-fonts-cjk-sans
  ] ++ builtins.filter pkgs.lib.isDerivation (builtins.attrValues pkgs.nerd-fonts);
}
