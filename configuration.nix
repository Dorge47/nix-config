# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.chris = {
    isNormalUser = true;
    description = "Christopher Andrade";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      kate
    #  thunderbird
    ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCg88GUiVCOaDnv2IRdcLDrnpTvpgFRi9Dzyf8l78ikoRX2vEkmT2ucUXvMhFULL9LHw1qDHgGctTCT2cr3VSJ17r/8Fbafq18Y7D6L1n9wgK4khdpkqy7BYHowbPpygroDAVGHIu5wgMaFGOHcanQntcFBqhGAhLYri0XQSO2OHlEgQFmVBS/usBAfcRMmxTzQ9QKFf/NLixymTQcXOO1grIqfBL6Y1vtXihPbU0xrmH6uNnlJqK/xVMqu3w5g09sLUZFoJjB2hQTaLyfAkiU4Co4HSktNzPqCc8a0TBxW32WjCcu6jinvPdPzBrQdR1+N4235lyA1vR27srxkd0gSgl84Dl2DXhfdbRUfg6sjQvvnNlxGHBXLZFmh8qGO8WOlppT9+3KSDYx/LVubRm8M7opyy3Q8h4YsnF/Ffb+86Nm9XLHRiF+DIF4mw/7ixSqveM4jqDSfAye0FyHumoxnHFw7hA9l+XSthNPFInDUZtQw7bRFL2JY3XO6ki5AIf0= chris@Chriss-MacBook-Pro.local"
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBHHcaMoJyFhLHOUCTBDFud3H0AlISWNAZzIf3m19V8sPjbJdl66/ohc0dD2tPCLu8cVTVT1Iu3Az7agRE64Ahc0="
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCpagnObeXHry8CouqaIgHCD81wecMMcRdQdPGq+1MiOLJB+QyJc5DJp3OOEX6y+7++mqiWiFEsOB56VnhstWuTCbuXFeMYbq4dBVWH0byWnJecyA7Gk/d6ou2BpaMHH6hV4yQhqEh2+2/AEbBoQdmdPlmrqAaYiUu4rmUOG4jVwZOUp6o1i0vAOhyeFfi1NSW+xzSGpE2j+oqZ9USuhgmCmEA+cB8U5VhEKq+232lL4cHYqiISh636cV5J/A5ioCUMW8sin1radNZyTd4ZX/Ik78g53DChQLdyIVHxKvflBcAazLm2UsH5fTGPCUxojIOrAqS3b9c94F9r1Uxl1lXi2iMtQm7CEOmEXjIV68zHC5mEjxOnbM3YfHH1ad0bDxaKJO6XjIa9n1IBb9YlMTvZR2TmJ+qiWiFe8zre7g0QRKYNiQ14cc13+QckM8tYf3JK1zv2ZPieTNGFDqUd42x3ebpC/4EIsUyDNbSixCU/H5HOu+Yq/pVCWjkzlRYNP9hvWwqnksRqvU4iR9CrCvYnXivZT0+0bOPvM+AryM/cnObgVrv113bJqZ+Zc0WxcaUfL4YQI70D65rG0ohB8wDFy6WkTGoMgWtgec3PxpIWKOGnXnr4scBhqLm2yHJGf8k7QMlKU/IDgAYlBlSmp1OC34XtlFquRbHut3684Lgp0Q== dorge@DESKTOP-KE19M4D"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [
  pkgs.vim
  pkgs.wget
  pkgs.fish
  pkgs.htop
  pkgs.vscode
  pkgs.gnupg
  pkgs.steam
  (pkgs.fortune.override { withOffensive = true; })
  pkgs.etcher # Disable Wi-Fi before running Etcher, its telemetry includes IP addresses
  pkgs.neofetch
  pkgs.telegram-desktop
  pkgs.discord
  pkgs.yt-dlp
  pkgs.vlc
  pkgs.git
  pkgs.hwinfo # Temporary install to figure out what kernel modules are needed by the wireless keyboard
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  # Enable fish shell as default
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  nixpkgs.config.permittedInsecurePackages = [
    "electron-19.1.9" # Needed for Etcher
  ];

  #Enable SSH
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    ports = [ 2222 ];
  };
  
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  
  # GnuPG
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "gtk2"; # Need something that works on gui and cli
    enableSSHSupport = true;
  };
  
  # Enable building from repo file
  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "nixos-config=/home/chris/Documents/GitHub/nix-config/configuration.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];
  
  # Garbage collection
  nix.settings.auto-optimise-store = true;
  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.gc.options = "--delete-older-than 30d";
}
