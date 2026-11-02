{ den, ... }: {
  den.aspects.danya._.nixarr = {
    includes = [
      den.aspects.nixarr
    ];

    nixos.nixarr = {
      mediaDir = "/zfspool/media";
      stateDir = "/zfspool/media/.state/nixarr";

      vpn = {
        enable = true;
        wgConf = "/home/aaron/airvpn.conf";
      };

      jellyfin = {
        enable = true;
        expose.https = {
          enable = true;
          domainName = "jellyfin.amdlift.com";
          acmeMail = "aaron.m.davis@comcast.net";
        };
      };

      audiobookshelf = {
        enable = true;
        expose.https = {
          enable = true;
          domainName = "audiobook.amdlift.com";
          acmeMail = "aaron.m.davis@comcast.net";
        };
        openFirewall = true;
      };

      exporters.enable = true;

      qbittorrent = {
        enable = true;
        openFirewall = true;
        vpn.enable = true;

        peerPort = 40083;
  
        extraConfig = {
          Preferences = {
            "WebUI\\Password_PBKDF2" = "@ByteArray(hf/jOOjiKDh5qCCypQoT7Q==:EZoc9RnDeZCDL7qDnYeEp4swuZz7e60CaLItWah+2CJnjzQ5Mv3bGZVjkLlQjPonN8opYtpXo+kVxdLH2tQvXw==)";
          };
        };
      };

      prowlarr = {
        settings-sync = {
          enable-nixarr-apps = true;

          # Define tags for organizing indexers
          tags = [ "usenet" "torrent" "private" "flaresolverr" ];

          indexers = [
            {
              sort_name = "yts";
              name = "YTS";
              tags = [ "torrent" ];
            }
            {
              sort_name = "1337x";
              name = "1337x";
              tags = [ "torrent" "flaresolverr" ];
            }
            {
              sort_name = "nyaa si";
              name = "Nyaa.si";
              tags = [ "torrent" ];
            }
            {
              sort_name = "pirate bay";
              name = "The Pirate Bay";
              tags = [ "torrent" ];
            }
            {
              sort_name = "eztv";
              name = "EZTV";
              tags = [ "torrent" "flaresolverr" ];
            }
            {
              sort_name = "knaben";
              name = "Knaben";
              tags = [ "torrent" ];
            }
            {
              sort_name = "milkie";
              name = "milkie";
              tags = [ "torrent" ];
              fields = {
                apikey = "psVSPZ64a8xdhwh+IAuSsDdgiGeUBjr5";
              };
            }
            {
              sort_name = "myanonamouse";
              enable = true;
              name = "MyAnonamouse";
              tags = [ "torrent" ];
              fields = {
                mamId = "eZIHgIkQh9Qu9SV-03OoFvO33kw2P-hO8DTbiOHXGq3OvdJV2m-9LyGJPtYjHZS5PUOqXw6fsDAPEcxArpn4mbvwmobOknFHKY1AEpDGZ56_MyegkARc_TK4fJO-rzEO4iKNvYBQdIQ6EDydmwpmdNY3upjFkw-nrHp1Ivzr2Ejj4eQAP6-5neYafi9MVikWYQ-4RwGWdLM24DBYjuIQmER5ODndziw7qvtlRfTSFQ8of_AqqD-d4H3WvO14WX5LHus4Fr38QYdSNwLbJ6IlfEsUHJ9HUFHbZNnH";
              };
            }
          ];
        };
      };

      radarr = {
        enable = true;
        settings-sync.downloadClients = [{
          name = "qBittorrent";
          implementation = "QBittorrent";
          fields = {
            host = "192.168.15.1";
            port = 8085;
            useSsl = false;
            username = "admin";
            password.secret = "/data/.secret/qbittorrent-password";
            movieCategory = "radarr";
          };
        }];
      };

      sonarr = {
        enable = true;
        settings-sync.downloadClients = [{
          name = "qBittorrent";
          implementation = "QBittorrent";
          fields = {
            host = "192.168.15.1";
            port = 8085;
            useSsl = false;
            username = "admin";
            password.secret = "/data/.secret/qbittorrent-password";
            tvCategory = "sonarr";
          };
        }];
      };
    };

    services.prowlarr.settings.auth.required = "DisabledForLocalAddresses";
    services.sonarr.settings.auth.required = "DisabledForLocalAddresses";
    services.radarr.settings.auth.required = "DisabledForLocalAddresses";
  };
}