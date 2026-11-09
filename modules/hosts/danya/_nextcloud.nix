{ config, lib, ... }: {
  environment.etc."nextcloud-admin-pass".text = "password";
  services.nextcloud = {
    enable = true;
    hostName = "nextcloud.amdlift.com";
    https = true;
    config.adminpassFile = "/etc/nextcloud-admin-pass";
    config = {
      dbtype = "sqlite";      
    };
    maxUploadSize = "4G";

    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps) news contacts calendar tasks richdocuments;
    };
    extraAppsEnable = true;
  };

  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = true;
    enableACME = true;
  };

  services.collabora-online = {
    enable = true;
    port = 9980; # default
    settings = {
      # Rely on reverse proxy for SSL
      ssl = {
        enable = false;
        termination = true;
      };

      # Listen on loopback interface only, and accept requests from ::1
      net = {
        listen = "loopback";
        post_allow.host = ["::1"];
      };

      # Restrict loading documents from WOPI Host nextcloud.example.com
      storage.wopi = {
        "@allow" = true;
        host = ["nextcloud.amdlift.com"];
      };

      # Set FQDN of server
      server_name = "collabora.amdlift.com";
    };
  };

  services.nginx.virtualHosts."collabora.amdlift.com" =  {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://[::1]:${toString config.services.collabora-online.port}";
        proxyWebsockets = true; # collabora uses websockets
      };
    };

  systemd.services.nextcloud-config-collabora = let
    inherit (config.services.nextcloud) occ;

    wopi_url = "http://[::1]:${toString config.services.collabora-online.port}";
    public_wopi_url = "https://collabora.amdlift.com";
    wopi_allowlist = lib.concatStringsSep "," [
      "127.0.0.1"
      "::1"
    ];
  in {
    wantedBy = ["multi-user.target"];
    after = ["nextcloud-setup.service" "coolwsd.service"];
    requires = ["coolwsd.service"];
    script = ''
      ${occ}/bin/nextcloud-occ config:app:set richdocuments wopi_url --value ${lib.escapeShellArg wopi_url}
      ${occ}/bin/nextcloud-occ config:app:set richdocuments public_wopi_url --value ${lib.escapeShellArg public_wopi_url}
      ${occ}/bin/nextcloud-occ config:app:set richdocuments wopi_allowlist --value ${lib.escapeShellArg wopi_allowlist}
      ${occ}/bin/nextcloud-occ richdocuments:setup
    '';
    serviceConfig = {
      Type = "oneshot";
    };
  };

  networking.hosts = {
    "127.0.0.1" = ["nextcloud.amdlift.com" "collabora.amdlift.com"];
    "::1" = ["nextcloud.amdlift.com" "collabora.amdlift.com"];
  };
}