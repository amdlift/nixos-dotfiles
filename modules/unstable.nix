{ inputs, ... }: {
  flake-file.inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  den.aspects.unstable.nixos = {
    nixpkgs.overlays = [
      (final: prev: {
        unstable = import inputs.nixpkgs-unstable {
          inherit (prev.stdenv.hostPlatform) system;
          inherit (prev) config;
        };
      })
    ];
  };
}
