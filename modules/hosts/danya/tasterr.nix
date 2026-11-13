{
  den.aspects.danya._.tasterr = {
    nixos = {
      virtualisation.oci-containers = {
        backend = "podman"; # or "docker"
        containers.tasterr = {
          image = "ghcr.io/zacharyarthur/tasterr:latest";
          user = "568:568";
          volumes = [ "/etc/tasterr:/data" ];
          environment = {
            SEERR_INTERNAL_URL = "http://127.0.0.1:5055";
            SEERR_EXTERNAL_URL = "https://seerr.amdlift.com";
          };
          # Keeps secrets out of the world-readable Nix store
          environmentFiles = [ "/etc/secrets/tasterr.env" ];
          extraOptions = [ "--network=host" ];
        };
      };

      # Ensure the data directory exists with the right ownership
      systemd.tmpfiles.rules = [
        "d /etc/tasterr 0750 568 568 -"
      ];

      services.nginx.virtualHosts."tasterr.amdlift.com" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8000";
        proxyWebsockets = true;
      };
    };
    };
  };
}
