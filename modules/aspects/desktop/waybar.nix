{ inputs, ... }:
{
  # Enablement only. The bar's layout and modules belong to the user;
  # its colours and fonts come from stylix.
  #
  # The package comes from the flake input, not nixpkgs: nixpkgs builds the
  # 0.15.0 release tarball, which predates the `mango/*` modules aaron's
  # layout uses.
  flake.modules.nixos.waybar =
    { pkgs, ... }:
    {
      home-manager.sharedModules = [
        {
          programs.waybar = {
            enable = true;
            package = inputs.waybar.packages.${pkgs.stdenv.hostPlatform.system}.waybar;
          };
        }
      ];
    };
}
