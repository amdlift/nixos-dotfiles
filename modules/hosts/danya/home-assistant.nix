{ den, ... }: {
  den.aspects.danya._.home-assistant.includes = [
    den.aspects.unstable
    den.aspects.agenix
  ];
  den.aspects.danya._.home-assistant.nixos = { pkgs, ... }: {
    services.home-assistant = {
      enable = true;
      package = pkgs.unstable.home-assistant;
      extraComponents = [
        # Components required to complete the onboarding
        "analytics"
        "androidtv_remote"
        "blink"
        "cast"
        "ecobee"
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

      customComponents = with pkgs.unstable.home-assistant-custom-components; [
        tuya_local
      ];

      customLovelaceModules = with pkgs.unstable.home-assistant-custom-lovelace-modules; [
        card-mod
      ];

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

        lovelace.resource_mode = "yaml";

        frontend.extra_module_url = [
          "/local/nixos-lovelace-modules/card-mod.js"
        ];

        person = [
          {
            name = "Aaron";
            id = "aaron";
            user_id = "2b109f9a9404405ea29ff64a886fef54";
            device_trackers = [ "device_tracker.aarons_iphone" ];
          }
        ];

        "automation nix" = [
          {
            alias = "Porch lights: sunset on, sunrise off";
            id = "bedroom_light_sun";
            trigger = [
              {
                platform = "sun";
                event = "sunset";
                id = "sunset";
              }
              {
                platform = "sun";
                event = "sunrise";
                id = "sunrise";
              }
            ];
            action = [
              {
                choose = [
                  {
                    conditions = [
                      {
                        condition = "trigger";
                        id = "sunset";
                      }
                    ];
                    sequence = [
                      {
                        service = "light.turn_on";
                        target.entity_id = "light.front_porch_recessed_lights";
                      }
                    ];
                  }
                  {
                    conditions = [
                      {
                        condition = "trigger";
                        id = "sunrise";
                      }
                    ];
                    sequence = [
                      {
                        service = "light.turn_off";
                        target.entity_id = "light.front_porch_recessed_lights";
                      }
                    ];
                  }
                ];
              }
            ];
          }
          {
            alias = "Bedroom: off when Aaron leaves, restore when home";
            id = "bedroom_away_restore";
            mode = "queued";
            trigger = [
              {
                platform = "state";
                entity_id = "person.aaron";
                from = "home";
                to = "not_home";
                for = "00:05:00";
                id = "left";
              }
              {
                platform = "state";
                entity_id = "person.aaron";
                to = "home";
                id = "arrived";
              }
            ];
            action = [
              {
                choose = [
                  {
                    conditions = [
                      {
                        condition = "trigger";
                        id = "left";
                      }
                    ];
                    sequence = [
                      {
                        service = "scene.create";
                        data = {
                          scene_id = "aaron_away_snapshot";
                          snapshot_entities = [
                            "light.aaron_s_bedroom_ceiling_fan_light"
                            "light.aaron_s_bedroom_ceiling_fan"
                          ];
                        };
                      }
                      {
                        service = "light.turn_off";
                        target.entity_id = [
                          "light.aaron_s_bedroom_ceiling_fan_light"
                          "light.aaron_s_bedroom_ceiling_fan"
                        ];
                      }
                    ];
                  }
                  {
                    conditions = [
                      {
                        condition = "trigger";
                        id = "arrived";
                      }
                      {
                        condition = "template";
                        value_template = "{{ states.scene.aaron_away_snapshot is not none }}";
                      }
                    ];
                    sequence = [
                      {
                        service = "scene.turn_on";
                        target.entity_id = "scene.aaron_away_snapshot";
                      }
                      {
                        service = "scene.delete";
                        target.entity_id = "scene.aaron_away_snapshot";
                      }
                    ];
                  }
                ];
              }
            ];
          }
        ];
        scene = [
          {
            id = "aaron_night";
            name = "Night";
            icon = "mdi:weather-night";
            entities = {
              "light.aaron_s_bedroom_ceiling_fan_light" = "off";
              "switch.aaron_s_bedroom_ceiling_fan" = "on";
            };
          }
        ];
      };

      lovelaceConfig = {
        title = "Home";
        views = [
          {
            title = "Main dashboard";
            path = "main";
            type = "sections";
            max_columns = 1;
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
                    entity = "light.aaron_s_bedroom_ceiling_fan_light";
                    icon = "mdi:lamps";
                    show_name = false;
                    show_state = false;
                    state_color = false;
                    grid_options = {
                      columns = 3;
                      rows = 2;
                    };
                    tap_action = {
                      action = "navigate";
                      navigation_path = "/nixos-lovelace/light-view";
                    };
                    card_mod.style = ''
                      ha-card {
                        --card-mod-icon-color: var(--amber-color);
                      }
                    '';
                  }
                  {
                    type = "button";
                    entity = "light.aaron_s_bedroom_ceiling_fan_light";
                    icon = "mdi:home-thermometer";
                    show_name = false;
                    show_state = false;
                    state_color = false;
                    grid_options = {
                      columns = 3;
                      rows = 2;
                    };
                    tap_action = {
                      action = "navigate";
                      navigation_path = "/nixos-lovelace/climate-view";
                    };
                    card_mod.style = ''
                      ha-card {
                        --card-mod-icon-color: var(--blue-color);
                      }
                    '';
                  }
                  {
                    type = "button";
                    entity = "light.aaron_s_bedroom_ceiling_fan_light";
                    icon = "mdi:shield-home";
                    show_name = false;
                    show_state = false;
                    state_color = false;
                    grid_options = {
                      columns = 3;
                      rows = 2;
                    };
                    tap_action = {
                      action = "navigate";
                      navigation_path = "/nixos-lovelace/security-view";
                    };
                    card_mod.style = ''
                      ha-card {
                        --card-mod-icon-color: var(--red-color);
                      }
                    '';
                  }
                  {
                    type = "button";
                    entity = "scene.night";
                    icon = "mdi:weather-night";
                    show_name = false;
                    show_state = false;
                    state_color = false;
                    grid_options = {
                      columns = 3;
                      rows = 2;
                    };
                    tap_action = {
                      action = "perform-action";
                      perform_action = "scene.turn_on";
                      target.entity_id = "scene.night";
                    };
                    card_mod.style = ''
                      ha-card {
                        --card-mod-icon-color: var(--indigo-color);
                      }
                    '';
                  }
                ];
              }
              {
                type = "grid";
                cards = [
                  {
                    type = "heading";
                    heading = "Rooms";
                  }
                  {
                    type = "tile";
                    entity = "light.aaron_s_bedroom_ceiling_fan_light";
                    icon = "mdi:ceiling-fan-light";
                    name = "Aaron's Bedroom";
                    show_state = false;
                    tap_action = {
                      action = "navigate";
                      navigation_path = "/nixos-lovelace/aarons-bedroom-view";
                    };
                  }
                  {
                    type = "tile";
                    entity = "light.foyer_ceiling_light";
                    icon = "mdi:ceiling-light";
                    name = "Foyer";
                    show_state = false;
                    tap_action = {
                      action = "navigate";
                      navigation_path = "/nixos-lovelace/foyer-view";
                    };
                  }
                  {
                    type = "tile";
                    entity = "light.front_porch_recessed_lights";
                    icon = "mdi:light-recessed";
                    name = "Front Porch";
                    show_state = false;
                    tap_action = {
                      action = "navigate";
                      navigation_path = "/nixos-lovelace/front-porch-view";
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
                    entity = "light.aaron_s_bedroom_ceiling_fan_light";
                    features = [ { type = "light-brightness"; } ];
                  }
                  {
                    type = "tile";
                    entity = "light.foyer_ceiling_light";
                    features = [ { type = "light-brightness"; } ];
                  }
                  {
                    type = "tile";
                    entity = "light.front_porch_recessed_lights";
                    features = [ { type = "light-brightness"; } ];
                  }
                ];
              }
            ];
          }
          {
            title = "Climate View";
            path = "climate-view";
            type = "sections";
            subview = true;
            back_path = "/nixos-lovelace/main";

            sections = [
              {
                type = "grid";
                cards = [
                  {
                    type = "heading";
                    heading = "2nd Floor";
                    icon = "mdi:home-floor-2";
                  }
                  {
                    type = "thermostat";
                    entity = "climate.hallway_thermostat";
                    name = "2nd Floor Thermostat";
                  }
                ];
              }
              {
                type = "grid";
                cards = [
                  {
                    type = "heading";
                    heading = "Attic";
                    icon = "mdi:home-floor-a";
                  }
                  {
                    type = "thermostat";
                    entity = "climate.attic_thermostat";
                    name = "Attic Thermostat";
                  }
                ];
              }
            ];
          }
          {
            title = "Security View";
            path = "security-view";
            type = "sections";
            subview = true;
            back_path = "/nixos-lovelace/main";

            sections = [
              {
                type = "grid";
              }
            ];
          }
          {
            title = "Aaron's Bedroom View";
            path = "aarons-bedroom-view";
            type = "sections";
            subview = true;
            back_path = "/nixos-lovelace/main";

            header = {
              layout = "center";
              card = {
                type = "markdown";
                text_only = true;
                content = "# Aaron's Bedroom";
              };
            };

            badges = [
              {
                type = "entity";
                entity = "sensor.aaron_s_bedroom_sensor_temperature";
                name = "Aaron's Bedroom Temperature";
                show_icon = true;
                state_content = [
                  "temperature"
                ];
              }
              {
                type = "entity";
                entity = "sensor.aaron_s_bedroom_sensor_humidity";
                name = "Aaron's Bedroom Humidity";
                show_icon = true;
                state_content = [
                  "humidity"
                ];
              }
            ];

            sections = [
              {
                type = "grid";
                cards = [
                  {
                    type = "heading";
                    heading = "Controls";
                  }
                  {
                    type = "tile";
                    entity = "light.aaron_s_bedroom_ceiling_fan_light";
                    icon = "mdi:ceiling-fan-light";
                    features = [ { type = "light-brightness"; } ];
                  }
                  {
                    type = "tile";
                    entity = "switch.aaron_s_bedroom_ceiling_fan";
                    icon = "mdi:ceiling-fan";
                    features = [ { type = "toggle"; } ];
                  }
                ];
              }
            ];
          }
          {
            title = "Foyer View";
            path = "foyer-view";
            type = "sections";
            subview = true;
            back_path = "/nixos-lovelace/main";

            header = {
              layout = "center";
              card = {
                type = "markdown";
                text_only = true;
                content = "# Foyer";
              };
            };

            sections = [
              {
                type = "grid";
                cards = [
                  {
                    type = "heading";
                    heading = "Controls";
                  }
                  {
                    type = "tile";
                    entity = "light.foyer_ceiling_light";
                    icon = "mdi:ceiling-light";
                    features = [ { type = "light-brightness"; } ];
                  }
                ];
              }
            ];
          }
          {
            title = "Front Porch View";
            path = "front-porch-view";
            type = "sections";
            subview = true;
            back_path = "/nixos-lovelace/main";

            header = {
              layout = "center";
              card = {
                type = "markdown";
                text_only = true;
                content = "# Front Porch";
              };
            };

            sections = [
              {
                type = "grid";
                cards = [
                  {
                    type = "heading";
                    heading = "Controls";
                  }
                  {
                    type = "tile";
                    entity = "light.front_porch_recessed_lights";
                    icon = "mdi:light-recessed";
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
