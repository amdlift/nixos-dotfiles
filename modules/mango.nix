{ inputs, ... }: {
  flake-file.inputs = {
    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.mango.nixos = {
    imports = [ inputs.mangowm.nixosModules.mango ];
    programs.mango.enable = true;
  };
}
