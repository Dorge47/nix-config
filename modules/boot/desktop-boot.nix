{ pkgs, ... }:
{
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable SSH on boot
  boot.kernelParams = [
    "ip=dhcp"
    #"default_hugepagesz=1G"
    #"hugepagesz=1G"
    #"hugepages=8"
  ];
  boot.initrd.kernelModules = [
    "usbhid"
    "r8152"
    "r8169"
    "mt7925e"
    "nct6775" # Case fans
    ];
  boot.initrd.network.enable = true;
  boot.initrd.network.ssh = {
    enable = true;
    port = 2222;
    authorizedKeys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCg88GUiVCOaDnv2IRdcLDrnpTvpgFRi9Dzyf8l78ikoRX2vEkmT2ucUXvMhFULL9LHw1qDHgGctTCT2cr3VSJ17r/8Fbafq18Y7D6L1n9wgK4khdpkqy7BYHowbPpygroDAVGHIu5wgMaFGOHcanQntcFBqhGAhLYri0XQSO2OHlEgQFmVBS/usBAfcRMmxTzQ9QKFf/NLixymTQcXOO1grIqfBL6Y1vtXihPbU0xrmH6uNnlJqK/xVMqu3w5g09sLUZFoJjB2hQTaLyfAkiU4Co4HSktNzPqCc8a0TBxW32WjCcu6jinvPdPzBrQdR1+N4235lyA1vR27srxkd0gSgl84Dl2DXhfdbRUfg6sjQvvnNlxGHBXLZFmh8qGO8WOlppT9+3KSDYx/LVubRm8M7opyy3Q8h4YsnF/Ffb+86Nm9XLHRiF+DIF4mw/7ixSqveM4jqDSfAye0FyHumoxnHFw7hA9l+XSthNPFInDUZtQw7bRFL2JY3XO6ki5AIf0= chris@Chriss-MacBook-Pro.local"
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBJd9CCADuU72Eqt2ZmOOzWbwutaJjpy9VIJ+CVI3Jtz9d41UIqXPJwEYHueEFbup8tkB7mSAmRxgFh3mr5xOwH8="
    ];
    hostKeys = [
      "/etc/secrets/initrd/ssh_host_rsa_key"
    ];
  };
  boot.kernelPackages = pkgs.linuxPackages_6_18; #Need 6.13+ kernel for RTL8125D support
}
