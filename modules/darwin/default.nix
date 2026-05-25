{ pkgs, inputs, ... }:
{
  imports = [
    ./nix.nix
    ./openssh.nix
    ./../../modules/users/chris-darwin.nix
  ];
  environment.systemPackages = with pkgs; [
    btop
    cowsay
    elinks
    ffmpeg
    fish
    (fortune.override { withOffensive = true; })
    git-crypt
    gnupg
    htop
    neofetch
    p7zip
    pinentry_mac
    python313
    restic
    tree
    twitch-cli
  ];
  
  environment.shells = [
    pkgs.fish
  ];
  
  programs.fish = {
    enable = true;
#    shellInit = ''
#    fish_add_path --prepend /run/current-system/sw/bin
#    fish_add_path --prepend /nix/var/nix/profiles/default/bin
#    fish_add_path --append /opt/homebrew/bin
#    fish_add_path --append /opt/homebrew/sbin
#    '';
  };
  
  programs.gnupg.agent.enable = true;
  
  nixpkgs.hostPlatform = "aarch64-darwin";
  
  system.stateVersion = 6;
  
  system.defaults = {
    dock = {
      autohide = true;
      show-recents = false;
    };
    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "Nlsv";
      ShowMountedServersOnDesktop = true;
      ShowPathbar = true;
      ShowStatusBar = true;
      _FXSortFoldersFirst = true;
    };
    NSGlobalDomain.AppleShowAllExtensions = true;
  };
  
  system.primaryUser = "chris";
}
