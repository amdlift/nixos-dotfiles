{ den, ... }: {
  den.aspects.gaming = {
    includes = [
      den.aspects.steam
    ];

    nixos.programs.gamemode.enable = true;
  };
}
