{ den, ... }: {
  den.aspects.danya._.immich.includes = [ den.aspects.unstable ];
  den.aspects.danya._.immich.nixos = { config, pkgs, ... }: {
    services.immich = {
      enable = true;
      package = pkgs.unstable.immich;
      host = "0.0.0.0";
      port = 2283;
      openFirewall = true;
      environment.IMMICH_LOG_LEVEL = "warn";
      mediaLocation = "/zfspool/photos";
      accelerationDevices = null;
    };

    services.redis.servers.immich.logLevel = "warning";

    services.nginx.virtualHosts."photos.amdlift.com" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://[::1]:${toString config.services.immich.port}";
        proxyWebsockets = true;
        recommendedProxySettings = true;
        extraConfig = ''
          client_max_body_size 50000M;
          proxy_read_timeout   600s;
          proxy_send_timeout   600s;
          send_timeout         600s;
        '';
      };
    };

    users.users.immich.extraGroups = [
      "video"
      "render"
    ];
  };
}
