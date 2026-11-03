{
  den.aspects.danya._.opengym = {
    nixos = {
      services.nginx.virtualHosts."gym.amdlift.com" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:7070";
        };
      };
    };
  };
}
