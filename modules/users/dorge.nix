{ pkgs, ... }:
{
  users.users.dorge = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
      kitty
    ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBJd9CCADuU72Eqt2ZmOOzWbwutaJjpy9VIJ+CVI3Jtz9d41UIqXPJwEYHueEFbup8tkB7mSAmRxgFh3mr5xOwH8= iphone16promax"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDBg/SsXqtyoF+Xm0b99/cwcaZR/EESwJi3rUh0VDAmVpKbt+DrGRQds2y7AcgGVZTnXIT95dD5ZKbLmx4SlY9zW7nK2kDm1KUHTefpQV6S5QYMrmrKuRaY4kbDJI5pi1l8mmiu3vIi+8aBOQsD35BF93et3Vt0km6YJuOQgdNfFLSjdESYuujJM/8CTvvfh5RL2xNKqhCxYW/ZoXXmALEsZAOvggxBb8tWSnFyLKPoaANj/9tz6umTiVdhg3nVEHGsA7DZEtEYT8+94yRgysJ1GTYvzDNu89aRWwZKGKTMZhvh+BNu6LI7F8YpfQhoP5uxgkUkZCDmEme+/BkWtrorVCJrGwBdQ6MZvW4hwSJadXUulkBmAXu0xMZcAKg7ZKEgGm00ki9f+n5660jjrq8AsREqUC9n2NUHi3sDH4s5OhSqeCoVC+R6xLFCu54Zp2Lu+PHMt8MwPINJFSleajx9jv6znebfU98UtBcMAe/drSzQrym+fLKzponJWPMGR7s= chris@nixos"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCg88GUiVCOaDnv2IRdcLDrnpTvpgFRi9Dzyf8l78ikoRX2vEkmT2ucUXvMhFULL9LHw1qDHgGctTCT2cr3VSJ17r/8Fbafq18Y7D6L1n9wgK4khdpkqy7BYHowbPpygroDAVGHIu5wgMaFGOHcanQntcFBqhGAhLYri0XQSO2OHlEgQFmVBS/usBAfcRMmxTzQ9QKFf/NLixymTQcXOO1grIqfBL6Y1vtXihPbU0xrmH6uNnlJqK/xVMqu3w5g09sLUZFoJjB2hQTaLyfAkiU4Co4HSktNzPqCc8a0TBxW32WjCcu6jinvPdPzBrQdR1+N4235lyA1vR27srxkd0gSgl84Dl2DXhfdbRUfg6sjQvvnNlxGHBXLZFmh8qGO8WOlppT9+3KSDYx/LVubRm8M7opyy3Q8h4YsnF/Ffb+86Nm9XLHRiF+DIF4mw/7ixSqveM4jqDSfAye0FyHumoxnHFw7hA9l+XSthNPFInDUZtQw7bRFL2JY3XO6ki5AIf0= chris@Chriss-MacBook-Pro.local"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCz2824Z6S5eFiKXtdDh1HMVSwuVmKSP01dHT/UoM7vBuuEWcZjpaMoqo/RRRyPskDI/Z5wL5k7l8gMGwP0A0gNEYxg5JvhCbe4ilur3cdXaLmrJsypIWO5EoorrpijMeIeUTKnLqr+pMckMV9sKeHlb9Pand1gaiAiy3Xc9suMyir+BdT11J1hzU8a9ZitD8U4vRtIDG9QNQJ4b0OCYqFgCJPczpgAtCBME++4jl2WakKRKlKbHSLxKhB7j6tT3VSltBPpmMt14seA+iPafA4YAPu1GasVY6FExFI7AtGtZxjHzkCjte6AgeKNUICd5ZLDwGax7Sz2vnsv+VPvhkxWP4vpEi6Umic1Gbce0LsWkIMF4aC0nhwd9Cf/HMO6r1SIGPlrAM8w+2fUA8ja8v5eAQ3rl/oqJbWrITM9RvNuUC97pDJhRgM9FVF7OIrXO2gVUpI4w2q3H8wBcgtCcb+KWlQjy8DGJuaQ7Fxrlgb9QQM5/CpRCE9DNVrtsqW998E= nu@raspberrypi"
    ];
  };
}
