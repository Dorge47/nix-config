# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let unstable = import <nixpkgs-unstable> {config = { allowUnfree = true; };};
secrets = import ./secrets.nix;
hyprlandConfig = import ./hyprland.nix;
hyprlockConfig = import ./hyprlock.nix;
home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz;
in {
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable SSH on boot
  boot.kernelParams = [ "ip=dhcp" ];
  boot.initrd.kernelModules = [ "usbhid" "r8152" "r8169" "mt7925e"];
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
  boot.kernelPackages = pkgs.linuxPackages_6_16; #Need 6.13+ kernel for RTL8125D support

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

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
  
  networking.firewall.allowedTCPPorts = [
    25565 # Minecraft
  ];
  
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
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  #services.greetd.enable = true;
  #services.greetd.settings = {
  #  default_session = {
  #    user = "greeter";
  #    command = ''
  #      ${pkgs.greetd.tuigreet}/bin/tuigreet --user-menu --cmd \
  #        "${pkgs.bash}/bin/bash -s <<'EOF'
  #          echo '1) Hyprland'
  #          echo '2) Plasma'
  #          read -p 'Choose session: ' choice
  #          case \"$choice\" in
  #            1) exec Hyprland ;;
  #            2) exec ${pkgs.kdePackages.plasma-workspace}/bin/startplasma-wayland ;;
  #            *) exec Hyprland ;;
  #          esac
#EOF"
  #    '';
  #  };
  #};
  programs.hyprland.enable = true;
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
  programs.waybar.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-hyprland
    pkgs.xdg-desktop-portal-gtk
  ];

  services.preload = {
    enable = true;
    package = pkgs.preload;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
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
      kdePackages.kate
    #  thunderbird
    ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCg88GUiVCOaDnv2IRdcLDrnpTvpgFRi9Dzyf8l78ikoRX2vEkmT2ucUXvMhFULL9LHw1qDHgGctTCT2cr3VSJ17r/8Fbafq18Y7D6L1n9wgK4khdpkqy7BYHowbPpygroDAVGHIu5wgMaFGOHcanQntcFBqhGAhLYri0XQSO2OHlEgQFmVBS/usBAfcRMmxTzQ9QKFf/NLixymTQcXOO1grIqfBL6Y1vtXihPbU0xrmH6uNnlJqK/xVMqu3w5g09sLUZFoJjB2hQTaLyfAkiU4Co4HSktNzPqCc8a0TBxW32WjCcu6jinvPdPzBrQdR1+N4235lyA1vR27srxkd0gSgl84Dl2DXhfdbRUfg6sjQvvnNlxGHBXLZFmh8qGO8WOlppT9+3KSDYx/LVubRm8M7opyy3Q8h4YsnF/Ffb+86Nm9XLHRiF+DIF4mw/7ixSqveM4jqDSfAye0FyHumoxnHFw7hA9l+XSthNPFInDUZtQw7bRFL2JY3XO6ki5AIf0= chris@Chriss-MacBook-Pro.local"
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBJd9CCADuU72Eqt2ZmOOzWbwutaJjpy9VIJ+CVI3Jtz9d41UIqXPJwEYHueEFbup8tkB7mSAmRxgFh3mr5xOwH8="
    ];
  };

  # Home manager
  home-manager.users.chris = {
    home.stateVersion = "23.11";
    programs = {
      vim.enable = true;
      htop.enable = true;
      firefox = {
        enable = true;
        package = unstable.firefox-devedition;
      };
      vscode = {
        enable = true;
        package = unstable.vscode;
      };
      yt-dlp.enable = true;
      git = {
        enable = true;
        userName = "Dorge47";
        userEmail = "Dorge47@users.noreply.github.com";
        signing = {
          signByDefault = true;
          key = "71107D53545117FE";
        };
      };
      chromium.enable = true;
      fzf.enable = true;
      kitty = {
        enable = true;
        settings = {
          confirm_os_window_close = 0;
        };
      };
      hyprlock = {
        enable = true;
        settings = hyprlockConfig;
      };
      waybar.enable = true;
      rofi = {
        enable = true;
        package = pkgs.rofi-wayland;
      };
      
    };
    home.packages = with pkgs; [
      wget
      (fortune.override { withOffensive = true; })
      neofetch
      telegram-desktop
      discord
      vlc
      obsidian
      twitch-cli
      steamcmd
      gimp
      p7zip
      fzf
      handbrake
      dbeaver-bin
      prismlauncher
      jdk23
      #Hyprland stuff
      libnotify
      swww
      wl-clipboard
      slurp
      grim
      ulauncher
    ];
    services = {
      mako.enable = true;
      swww.enable = true;
    };
    wayland.windowManager.hyprland = {
      enable = true;
      settings = hyprlandConfig; # See hyprland.nix
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gnupg
    nodejs
    hwinfo
    pciutils
    libsForQt5.filelight
    openvpn
    kmymoney
    obs-studio
  ];
  fonts.packages = with pkgs; [
    
  ] ++ builtins.filter pkgs.lib.isDerivation (builtins.attrValues pkgs.nerd-fonts);
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
    "electron-25.9.0" # Required for obsidian
  ];

  #Enable SSH
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    ports = [ 2222 ];
  };
  
  # Enable Steam
  programs.steam.enable = true;
  
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  
  #Enable openrgb
  services.hardware.openrgb.enable = true;
  
  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  
  # GnuPG
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gtk2; # Need something that works on gui and cli
    enableSSHSupport = true;
  };
  
  # Enable building from repo file
  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "nixos-config=/home/chris/Documents/GitHub/nix-config/configuration.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];
  
  #Mount drives
  fileSystems."/run/media/chris/New Volume" = #E drive
    { device = "/dev/disk/by-uuid/01D7DC1481BB6E80";
      fsType = "ntfs";
    };
    
  fileSystems."/run/media/chris/Basic data partition" = #Windows drive
    { device = "/dev/disk/by-uuid/01D9D96304239210";
      fsType = "ntfs";
    };
  
  # Garbage collection
  nix.settings.auto-optimise-store = true;
  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.gc.options = "--delete-older-than 30d";
}
