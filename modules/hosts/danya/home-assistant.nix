{ den, ... }: {
  den.aspects.danya._.home-assistant.includes = [ den.aspects.unstable ];
  den.aspects.danya._.home-assistant.nixos = { pkgs, ... }: {
    services.home-assistant = {
      enable = true;
      package = pkgs.unstable.home-assistant;
      extraComponents = [
        # Components required to complete the onboarding
        "analytics"
        "androidtv_remote"
        "cast"
        "google_translate"
        "homekit_controller"
        "lutron_caseta"
        "matter"
        "met"
        "otbr"
        "radio_browser"
        "thread"
        "tplink"
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

            header = {
              layout = "center";
              card = {
                type = "markdown";
                text_only = true;
                content = "# Hello, {{ user }}";
              };
            };

            badges = [
              {
                type = "entity";
                entity = "weather.forecast_home";
                name = "Outside";
                show_icon = true;
                state_content = [
                  "state"
                  "temperature"
                ];
              }
            ];

            sections = [
              {
                type = "grid";
                cards = [
                  {
                    type = "button";
                    entity = "light.aarons_bedroom_aarons_bedroom_ceiling_fan_light";
                    name = " ";
                    icon = "mdi:lamps";
                    hide_state = true;
                    vertical = true;
                    color = "amber";
                    grid_options = {
                      columns = 3;
                      rows = 2;
                    };
                    tap_action = {
                      action = "navigate";
                      navigation_path = "/nixos-lovelace/light-view";
                    };
                  }
                  {
                    type = "button";
                    entity = "light.aarons_bedroom_aarons_bedroom_ceiling_fan_light";
                    name = " ";
                    icon = "mdi:shield-home";
                    hide_state = true;
                    vertical = true;
                    grid_options = {
                      columns = 3;
                      rows = 2;
                    };
                  }
                  {
                    type = "button";
                    entity = "light.aarons_bedroom_aarons_bedroom_ceiling_fan_light";
                    name = " ";
                    icon = "mdi:home-thermometer";
                    hide_state = true;
                    vertical = true;
                    grid_options = {
                      columns = 3;
                      rows = 2;
                    };
                  }
                ];
              }
            ];
          }
          {
            title = "Light View";
            path = "light-view";
            type = "sections";
            subview = true;
            back_path = "/nixos-lovelace/main";

            sections = [
              {
                type = "grid";
                cards = [
                  {
                    type = "tile";
                    entity = "light.aarons_bedroom_aarons_bedroom_ceiling_fan_light";
                    features = [ { type = "light-brightness"; } ];
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
