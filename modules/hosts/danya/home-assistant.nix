{ den, ... }: {
  den.aspects.danya._.home-assistant.includes = [ den.aspects.unstable ];
  den.aspects.danya._.home-assistant.nixos = { pkgs, ... }: {
    services.home-assistant = {
      enable = true;
      package = pkgs.unstable.home-assistant;
      extraComponents = [
        # Components required to complete the onboarding
        "analytics"
        "google_translate"
        "matter"
        "met"
        "otbr"
        "radio_browser"
        "thread"
        "shopping_list"
        # Recommended for fast zlib compression
        # https://www.home-assistant.io/integrations/isal
        "isal"
      ];

      extraPackages = ps: with ps; [ psycopg2 ];

      config = {
        # Includes  sudo ot-ctl router tabledependencies for a basic setup
        # https://www.home-assistant.io/integrations/default_config/
        default_config = { };
        homeassistant = {
          name = "Home";
          unit_system = "us_customary";
          time_zone = "America/Chicago";
        };

        http = {
          server_host = "::1";
          trusted_proxies = [ "::1" ];
          use_x_forwarded_for = true;
        };

        recorder.db_url = "postgresql://@/hass";
      };

      lovelaceConfig = {
        title = "Home";
        views = [
          {
            title = "Main dashboard";
            path = "main";
            type = "sections";
            max_columns = 4;
            dense_section_placement = true;

            sections = [
              {
                type = "grid";
                cards = [
                  {
                    type = "heading";
                    heading = "Test title";
                  }
                ];
              }
            ];
          }
        ];
      };
    };

    services.nginx = {
      recommendedProxySettings = true;
      virtualHosts."home.amdlift.com" = {
        forceSSL = true;
        enableACME = true;
        extraConfig = ''
          proxy_buffering off;
        '';
        locations."/" = {
          proxyPass = "http://[::1]:8123";
          proxyWebsockets = true;
        };
      };
    };

    services.postgresql = {
      enable = true;
      ensureDatabases = [ "hass" ];
      ensureUsers = [
        {
          name = "hass";
          ensureDBOwnership = true;
        }
      ];
    };
  };
}
