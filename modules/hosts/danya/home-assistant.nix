{ den, ... }:
{
  den.aspects.danya._.home-assistant = {
    includes = [
      den.aspects.unstable
      den.aspects.agenix
    ];

    nixos =
      { pkgs, lib, ... }:
      let
        # ── Entities ────────────────────────────────────────────────
        bedroomLight = "light.aaron_s_bedroom_ceiling_fan_light";
        bedroomFan = "switch.aaron_s_bedroom_ceiling_fan";
        foyerLight = "light.foyer_ceiling_light";
        porchLight = "light.front_porch_recessed_lights";
        closetLight = "light.aaron_s_closet_dimmer_switch";

        # Game Room
        gameRoomLights = "light.game_room_main_lights";
        gameRoomFan = "switch.game_room_ceiling_fan";

        # ── Automation helpers ──────────────────────────────────────
        # A `choose` branch that runs when the trigger with `id` fired.
        onTrigger = id: sequence: {
          conditions = [
            {
              condition = "trigger";
              inherit id;
            }
          ];
          inherit sequence;
        };

        # ── Lovelace helpers ────────────────────────────────────────
        base = "/nixos-lovelace";

        navigate = view: {
          action = "navigate";
          navigation_path = "${base}/${view}";
        };

        centeredHeader = text: {
          layout = "center";
          card = {
            type = "markdown";
            text_only = true;
            content = "# ${text}";
          };
        };

        heading = text: {
          type = "heading";
          heading = text;
        };

        brightnessTile = entity: {
          type = "tile";
          inherit entity;
          features = [ { type = "light-brightness"; } ];
        };

        # Big icon-only button on the main view.
        iconButton =
          {
            icon,
            color,
            tap_action,
          }:
          {
            type = "button";
            inherit icon tap_action;
            show_name = false;
            show_state = false;
            state_color = false;
            grid_options = {
              columns = 3;
              rows = 2;
            };
            card_mod.style = ''
              ha-card {
                --card-mod-icon-color: var(--${color}-color);
              }
            '';
          };

        # Every subview shares these defaults.
        subview =
          attrs:
          {
            type = "sections";
            subview = true;
            back_path = "${base}/main";
          }
          // attrs;

        # ── Rooms: one entry generates a main-view tile and a subview ──
        rooms = [
          {
            slug = "aarons-bedroom";
            name = "Aaron's Bedroom";
            entity = bedroomLight;
            icon = "mdi:ceiling-fan-light";
            badges =
              lib.mapAttrsToList
                (kind: label: {
                  type = "entity";
                  entity = "sensor.aaron_s_bedroom_sensor_${kind}";
                  name = "Aaron's Bedroom ${label}";
                  show_icon = true;
                  state_content = [ kind ];
                })
                {
                  temperature = "Temperature";
                  humidity = "Humidity";
                };
            extraTiles = [
              {
                type = "tile";
                entity = bedroomFan;
                icon = "mdi:ceiling-fan";
                features = [ { type = "toggle"; } ];
              }
            ];
          }
          {
            slug = "foyer";
            name = "Foyer";
            entity = foyerLight;
            icon = "mdi:ceiling-light";
          }
          {
            slug = "front-porch";
            name = "Front Porch";
            entity = porchLight;
            icon = "mdi:light-recessed";
          }
          {
            slug = "game-room";
            name = "Game Room";
            entity = gameRoomLights;
            icon = "mdi:controller";
            extraTiles = [
              {
                type = "tile";
                entity = gameRoomFan;
                icon = "mdi:ceiling-fan";
                features = [ { type = "toggle"; } ];
              }
            ];
          }
        ];

        roomTile = room: {
          type = "tile";
          inherit (room) entity icon name;
          show_state = false;
          tap_action = navigate "${room.slug}-view";
        };

        roomView =
          room:
          subview {
            title = "${room.name} View";
            path = "${room.slug}-view";
            header = centeredHeader room.name;
            badges = room.badges or [ ];
            sections = [
              {
                type = "grid";
                cards = [
                  (heading "Controls")
                  (brightnessTile room.entity // { inherit (room) icon; })
                ]
                ++ room.extraTiles or [ ];
              }
            ];
          };

        thermostatSection = name: icon: entity: {
          type = "grid";
          cards = [
            ((heading name) // { inherit icon; })
            {
              type = "thermostat";
              inherit entity;
              name = "${name} Thermostat";
            }
          ];
        };
      in
      {
        age.secrets.hass-secrets = {
          file = ../../../secrets/hass-secrets.age;
          path = "/var/lib/hass/secrets.yaml";
          owner = "hass";
          group = "hass";
          mode = "0400";
        };

        services.home-assistant = {
          enable = true;
          package = pkgs.unstable.home-assistant;

          extraComponents = [
            "analytics"
            "androidtv"
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
            "isal" # fast zlib compression
          ];

          extraPackages = ps: [ ps.psycopg2 ];

          customComponents = [ pkgs.unstable.home-assistant-custom-components.tuya_local ];
          customLovelaceModules = [ pkgs.unstable.home-assistant-custom-lovelace-modules.card-mod ];

          config = {
            # https://www.home-assistant.io/integrations/default_config/
            default_config = { };

            homeassistant = {
              name = "Home";
              unit_system = "us_customary";
              time_zone = "America/Chicago";
              latitude = "!secret home_latitude";
              longitude = "!secret home_longitude";
              elevation = "!secret home_elevation";
            };

            http = {
              server_host = "::1";
              trusted_proxies = [ "::1" ];
              use_x_forwarded_for = true;
            };

            recorder.db_url = "postgresql://@/hass";
            lovelace.resource_mode = "yaml";
            frontend.extra_module_url = [ "/local/nixos-lovelace-modules/card-mod.js" ];

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
                id = "bedroom_light_sun"; # kept so HA history/traces stay linked
                trigger =
                  map
                    (event: {
                      platform = "sun";
                      inherit event;
                      id = event;
                    })
                    [
                      "sunset"
                      "sunrise"
                    ];
                action = [
                  {
                    choose = [
                      (onTrigger "sunset" [
                        {
                          service = "light.turn_on";
                          target.entity_id = porchLight;
                        }
                      ])
                      (onTrigger "sunrise" [
                        {
                          service = "light.turn_off";
                          target.entity_id = porchLight;
                        }
                      ])
                    ];
                  }
                ];
              }

              (
                let
                  awayEntities = [
                    bedroomLight
                    bedroomFan
                  ];
                  snapshot = "scene.aaron_away_snapshot";
                in
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
                        (onTrigger "left" [
                          {
                            service = "scene.create";
                            data = {
                              scene_id = "aaron_away_snapshot";
                              snapshot_entities = awayEntities;
                            };
                          }
                          # homeassistant.turn_off works for both the light and the switch
                          {
                            service = "homeassistant.turn_off";
                            target.entity_id = awayEntities;
                          }
                        ])
                        (onTrigger "arrived" [
                          # A condition inside a sequence stops it when false.
                          {
                            condition = "template";
                            value_template = "{{ states.${snapshot} is not none }}";
                          }
                          {
                            service = "scene.turn_on";
                            target.entity_id = snapshot;
                          }
                          {
                            service = "scene.delete";
                            target.entity_id = snapshot;
                          }
                        ])
                      ];
                    }
                  ];
                }
              )
            ];

            scene = [
              {
                id = "aaron_night";
                name = "Night";
                icon = "mdi:weather-night";
                entities = {
                  ${bedroomLight} = "off";
                  ${bedroomFan} = "on";
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
                header = centeredHeader "Hello, {{ user }}";

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
                      (iconButton {
                        icon = "mdi:lamps";
                        color = "amber";
                        tap_action = navigate "light-view";
                      })
                      (iconButton {
                        icon = "mdi:home-thermometer";
                        color = "blue";
                        tap_action = navigate "climate-view";
                      })
                      (iconButton {
                        icon = "mdi:shield-home";
                        color = "red";
                        tap_action = navigate "security-view";
                      })
                      (
                        iconButton {
                          icon = "mdi:weather-night";
                          color = "indigo";
                          tap_action.action = "toggle"; # toggling a scene activates it
                        }
                        // {
                          entity = "scene.night";
                        }
                      )
                    ];
                  }
                  {
                    type = "grid";
                    cards = [ (heading "Rooms") ] ++ map roomTile rooms;
                  }
                ];
              }

              (subview {
                title = "Light View";
                path = "light-view";
                sections = [
                  {
                    type = "grid";
                    cards = map brightnessTile [
                      bedroomLight
                      foyerLight
                      porchLight
                      closetLight
                    ];
                  }
                ];
              })

              (subview {
                title = "Climate View";
                path = "climate-view";
                sections = [
                  (thermostatSection "2nd Floor" "mdi:home-floor-2" "climate.hallway_thermostat")
                  (thermostatSection "Attic" "mdi:home-floor-a" "climate.attic_thermostat")
                ];
              })

              (subview {
                title = "Security View";
                path = "security-view";
                sections = [ { type = "grid"; } ];
              })
            ]
            ++ map roomView rooms;
          };
        };

        services.nginx = {
          recommendedProxySettings = true;
          virtualHosts."home.amdlift.com" = {
            forceSSL = true;
            enableACME = true;
            extraConfig = "proxy_buffering off;";
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
  };
}
