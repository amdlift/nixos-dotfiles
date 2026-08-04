{ self, ... }:
let
  # Nothing here is class-specific: home-manager's `programs.btop` exists
  # identically under NixOS and nix-darwin, so one definition serves both.
  shared = {
    home-manager.sharedModules = [ { programs.btop.enable = true; } ];
  };
in
{
  flake.modules.nixos.btop = shared;
  flake.modules.darwin.btop = shared;

  # CUDA-enabled variant for hosts with (or destined for) an NVIDIA GPU.
  # Refines the base aspect instead of restating it, so a host imports exactly
  # one of `btop` / `btop-cuda`.
  flake.modules.nixos.btop-cuda = {
    imports = [ self.nixosModules.btop ];

    home-manager.sharedModules = [
      ({ pkgs, ... }: { programs.btop.package = pkgs.btop-cuda; })
    ];
  };
}
