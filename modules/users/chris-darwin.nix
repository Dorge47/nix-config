{ pkgs, ... }:
{
  users.users.chris = {
    home = "/Users/chris";
    shell = pkgs.fish;
  };
}
