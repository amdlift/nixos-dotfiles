{ den, ... }: {
  den.aspects.steam = {
    includes = [
      (den._.unfree [ "steam" "steam-unwrapped" ])
    ];

    nixos.programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };
}