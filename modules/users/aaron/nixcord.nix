{ den, inputs, ... }: {
  flake-file.inputs = {
    nixcord.url = "github:4evy/nixcord";
  };

  den.aspects.aaron._.nixcord = {
    includes = [
      (den._.unfree [ "discord" ])
    ];
    homeManager = {
      imports = [ inputs.nixcord.homeModules.nixcord ];
      programs.nixcord = {
        enable = true;
        discord.vencord.enable = true;
      };
    };
  };
}