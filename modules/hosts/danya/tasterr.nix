{
  den.aspects.danya._.tasterr = {
    nixos = {
      virtualisation.oci-containers = {
        backend = "podman"; # or "docker"
        containers.tasterr = {
          image = "ghcr.io/zacharyarthur/tasterr:latest";
          user = "568:568";
          ports = [ "8000:8000" ];
          volumes = [ "/etc/tasterr:/data" ];
          environment = {
            SEERR_INTERNAL_URL = "http://192.168.1.211:5055";
            SEERR_EXTERNAL_URL = "https://seerr.amdlift.com";
          };
          # Keeps secrets out of the world-readable Nix store
          environmentFiles = [ "/etc/secrets/tasterr.env" ];
        };
      };

      # Ensure the data directory exists with the right ownership
      systemd.tmpfiles.rules = [
        "d /etc/tasterr 0750 568 568 -"
      ];
    };
  };
}
