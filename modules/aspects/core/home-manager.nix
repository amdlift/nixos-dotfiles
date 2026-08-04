{ inputs, ... }:
let
  # identical on both classes; only the entrypoint module differs
  settings = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };
in
{
  flake.modules.nixos.home-manager.imports = [
    inputs.home-manager.nixosModules.default
    settings
  ];

  flake.modules.darwin.home-manager.imports = [
    inputs.home-manager.darwinModules.default
    settings
  ];
}
