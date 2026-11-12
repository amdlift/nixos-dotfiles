{ den, ... }: {
  den.aspects.danya = {
    includes = with den.aspects; [
      bluetooth
      byparr
      flatpak
      matter
      network-manager
      nvidia
      otbr
      podman
      ssh
      systemd-boot
      unstable
      usb

      danya._.home-assistant
      danya._.immich
      danya._.minecraft-server
      danya._.nixarr
      danya._.opengym
      danya._.zfs

      (den._.unfree [
        "claude-code"
      ])
    ];

    nixos = { pkgs, ... }: {
      imports = [
        ./_hardware.nix
        ./_nextcloud.nix
      ];

      nix.settings.trusted-users = [ "aaron" ];

      environment.systemPackages = with pkgs; [
        beets
        btop-cuda
        claude-code
        podman-compose
        zfs
      ];

      time.timeZone = "America/Chicago";

      i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
      };

      networking.firewall.allowedTCPPorts = [
        8087
        8088
      ];

      services.nginx.virtualHosts."amberlargo.com" = {
        serverAliases = [ "www.amberlargo.com" ];
        enableACME = true; # get a Let's Encrypt cert
        forceSSL = true; # redirect http -> https
        locations."/" = {
          proxyPass = "http://127.0.0.1:8087";
          proxyWebsockets = true; # harmless if the app doesn't use them
        };
      };

      hardware.nvidia.open = false;
      hardware.nvidia.branch = "legacy_580";
    };
  };
}
