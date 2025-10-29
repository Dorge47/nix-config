# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:
let unfree = import <nixos> {config = { allowUnfree = true; };};
secrets = import ./secrets.nix;
in {
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      #<nixos-hardware/raspberry-pi/4>
    ];
  # hardware = {
  #   raspberri-pi."4".apply-overlays-dtmerge.enable = true;
  #   deviceTree = {
  #     enable = true;
  #     filter = "*rpi-4-*.dtb";
  #   };
  # };
  boot = {
    loader = {
      # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
      grub.enable = false;
      # Enables the generation of /boot/extlinux/extlinux.conf
      generic-extlinux-compatible.enable = true;
    };
    kernelPackages = pkgs.linuxPackages_rpi4;
    initrd.availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" ];
  };

  networking.hostName = "nixPi"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # services.displayManager.sddm.enable = true;
  # services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
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

  programs.git.enable = true;
  programs.htop.enable = true;
  programs.fish.enable = true;
  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    libraspberrypi
    raspberrypi-eeprom
    cifs-utils
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gtk2;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  services.nginx = {
    enable = true;
  };

  # systemd-resolved
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ]; # "use as default interface for all requests"
    # (see man resolved.conf)
    # let Avahi handle mDNS publication
    extraConfig = ''
      DNSOverTLS=opportunistic
      MulticastDNS=resolve
    '';
    llmnr = "true";
  };

  networking.nameservers = [
    secrets.controlDns # Use the DNS server defined in secrets.nix
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # fileSystems = {
  #   "/" = {
  #     device = "/dev/disk/by-label/NIXOS_SD";
  #     fsType = "ext4";
  #     options = [ "noatime" ];
  #   };
  # };

  hardware.enableRedistributableFirmware = true;

  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "nixos-config=/home/dorge/Documents/GitHub/nix-config/raspi.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];

  fileSystems."/run/media/dorge/plex" = #Fileserver
    { device = "//192.168.1.183/plex";
      fsType = "cifs";
      options = [ "credentials=/home/dorge/credentials.txt" ];
    };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}

