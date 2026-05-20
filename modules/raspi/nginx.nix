{ pkgs, secrets, ... }:
{
  services.nginx = {
    enable = true;
    virtualHosts = {
      "${secrets.acmeStuff.mainDomain}" = {
        forceSSL = true;
        useACMEHost = "${secrets.acmeStuff.mainDomain}";
        serverAliases = secrets.nginxStuff.aliases;
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
      "${secrets.nginxStuff.homeAssistantDomain}" = {
        forceSSL = true;
        useACMEHost = "${secrets.acmeStuff.mainDomain}";
        locations."/" = {
          extraConfig = secrets.nginxStuff.homeAssistantConfig;
        };
      };
      
      "${secrets.nginxStuff.plexDomain}" = {
        forceSSL = true;
        useACMEHost = "${secrets.acmeStuff.mainDomain}";
        locations."/" = {
          extraConfig = secrets.nginxStuff.plexConfig;
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
}
