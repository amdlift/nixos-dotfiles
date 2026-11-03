{
  den.aspects.byparr = {
    virtualisation.oci-containers.containers.byparr = {
      image = "ghcr.io/thephaseless/byparr:latest";
      autoStart = true;
      ports = [ "8191:8191" ];
      environment = {
        HOST = "0.0.0.0";
        PORT = "8191";
        # PROXY_SERVER, PROXY_USERNAME, PROXY_PASSWORD if you use one
      };
      extraOptions = [
        "--shm-size=512m" # from the README's Proxmox/LXC troubleshooting note
      ];
    };
  };
}
