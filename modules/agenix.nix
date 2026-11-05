{ inputs, ... }: {
  flake-file.inputs = {
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  den.aspects.agenix = { pkgs, ... }: {
    nixos = {
      imports = [ inputs.agenix.nixosModules.default ];
    };

    environment.systemPackages = [
      inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
