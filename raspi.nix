# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:
let unfree = import <nixos> {config = { allowUnfree = true; };};
secrets = import ./secrets.nix;
#nginxConfig = import ./raspi/nginx.nix; # Fix later
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
  

   # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.



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
    btop
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

  # webserver
  security.acme = {
    acceptTerms = true;
    defaults.email = "admin@tulaus.org";
    certs."tulaus.dev" = {
      domain = "tulaus.dev";
      extraDomainNames = secrets.domainNames;
      dnsProvider = "cloudflare";
      environmentFile = "/home/dorge/Documents/GitHub/nix-config/acme-cloudflare.env";
      group = "nginx";
    };
  };
  services.nginx = {
    enable = true;
    virtualHosts = {
      "tulaus.dev" = {
        forceSSL = true;
        useACMEHost = "tulaus.dev";
        # All serverAliases will be added as extra domain names on the certificate.
        serverAliases = [ "tulaus.dev" "www.tulaus.dev" "tulaus.com" "www.tulaus.com" "tulaus.org" "www.tulaus.org" "velvetbot.net" "www.velvetbot.net" "fantomethief.net" "www.fantomethief.net" "cartwebapp.net" "www.cartwebapp.net" "mc.cartwebapp.net" ];
        root = "/var/www/Website";
        locations = {
          "/" = {
            index = "index.php index.html";
          };
          "~ \\.php$" = {
            extraConfig = ''
              fastcgi_pass unix:/run/phpfpm/www.sock;
              fastcgi_index index.php;
              include ${pkgs.nginx}/conf/fastcgi.conf;
            '';
          };
          "/remotefiles/" = {
            extraConfig = ''
              allow all;
              autoindex on;
            '';
          };
          "~ /\\.(?!well-known).*" = {
            extraConfig = ''
              deny all;
            '';
          };
          "~* \\.(git|env|json|lock|log|md|ini|bak|swp|yml|yaml)$" = {
            extraConfig = ''
              deny all;
            '';
          };
          "= /403.html" = {
            root = "/var/www/Website";
            extraConfig = ''
              internal;
            '';
          };
          "= /Chris_Andrade_0xAE9A1BE8_public.asc" = {
            return = "403";
          };
          "~* \\.(jpg|jpeg|png|gif|ico|css|js|svg|woff2?|ttf|eot|otf)$" = {
            extraConfig = ''
              access_log off;
              expires 30d;
            '';
          };
          "~* \\.(?!php|html|css|js|jpg|jpeg|png|gif|ico|svg)$" = {
            extraConfig = ''
              deny all;
            '';
          };
        };
        extraConfig = ''
          error_page 403 /403.html;
        '';
      };

      # We can also add a different vhost and reuse the same certificate
      # but we have to append extraDomainNames manually beforehand:
      # security.acme.certs."foo.example.com".extraDomainNames = [ "baz.example.com" ];
      "ha.tulaus.dev" = {
        forceSSL = true;
        useACMEHost = "tulaus.dev";
        locations."/" = {
          extraConfig = ''
          proxy_pass http://192.168.1.48:8123;
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "upgrade";
          '';
        };
      };
      
      "plex.tulaus.dev" = {
        forceSSL = true;
        useACMEHost = "tulaus.dev";
        locations."/" = {
          extraConfig = ''
            proxy_pass http://192.168.1.214:32400;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
          '';
        };
      };
    };
  };
  services.phpfpm.pools.www = {
    user = "nginx";
    settings = {
      "listen.owner" = "nginx";
      "listen.group" = "nginx";
      "listen.mode" = "0660";
      "pm" = "dynamic";
      "pm.max_children" = 32;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 2;
      "pm.max_spare_servers" = 4;
    };
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
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
  networking.firewall.allowedUDPPorts = [
    80
    443
  ];
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

