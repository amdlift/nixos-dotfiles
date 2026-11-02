{ inputs, ... }: {
  flake-file.inputs = {
    nixarr.url = "github:nix-media-server/nixarr";
  };

  den.aspects.nixarr.nixos = {
    imports = [ inputs.nixarr.nixosModules.default ];
    nixarr.enable = true;
  };
}
