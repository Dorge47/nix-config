{ pkgs, ... }:
{
  users.users.chris = {
    home = "/Users/chris";
    shell = pkgs.fish;
  };
  
  home-manager.users.chris = import ../../home/chris-darwin;
}
