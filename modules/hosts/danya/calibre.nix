{
  den.aspects.danya._.calibre.nixos = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.calibre ]; # provides calibredb for the import

    services.calibre-server = {
      enable = true;
      libraries = [ "/zfspool/media/CalibreLibrary" ];
      host = "0.0.0.0";
      port = 8090;
      openFirewall = true;
      group = "media";
    };

    services.calibre-web = {
      enable = true;
      group = "media";
      listen.ip = "0.0.0.0";
      listen.port = 8091;
      openFirewall = true;
      options = {
        calibreLibrary = "/zfspool/media/CalibreLibrary";
        enableBookUploading = true;
        enableKepubify = true;
      };
    };

    services.nginx.virtualHosts."calibre.amdlift.com" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8091";
        extraConfig = ''
          client_max_body_size 500M;
          proxy_buffer_size 128k;
          proxy_buffers 4 256k;
          proxy_busy_buffers_size 256k;
        '';
      };
    };
  };
}
