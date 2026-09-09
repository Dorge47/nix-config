{ pkgs, inputs, ... }:
let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
  };
  flameshotWithoutQt6ct = pkgs.symlinkJoin {
    name = "flameshot-without-qt6ct";

    paths = [ unstable.flameshot ]; # Need unstable for Frameshot 14, 13 doesn't like when there's not a monitor at 0,0

    nativeBuildInputs = [ pkgs.makeWrapper ];

    postBuild = ''
      wrapProgram $out/bin/flameshot \
        --unset QT_QPA_PLATFORMTHEME
    '';
    
    meta = unstable.flameshot.meta // {
      mainProgram = "flameshot";
    };
  
  };

in {
  imports = [
    ./hyprlock.nix
    ./settings.nix
  ];
  home.packages = with pkgs; [
    libnotify
    wl-clipboard
    slurp
    grim
    kdePackages.dolphin
    ulauncher
    blueman
    wev
    kdePackages.qt6ct
  ];
  programs = {
    mpvpaper.enable = true;
    hyprshot.enable = true;
    jq.enable = true;
  };
  services = {
    mako.enable = true;
    hyprpolkitagent.enable = true;
    flameshot = {
      enable = true;
      package = flameshotWithoutQt6ct;
    };
  };
  wayland.windowManager.hyprland = {
    enable = true;
    portalPackage = null;
  };
}
