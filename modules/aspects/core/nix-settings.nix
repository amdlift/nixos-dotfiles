let
  shared = {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
in
{
  flake.modules.nixos.nix-settings = shared;
  flake.modules.darwin.nix-settings = shared;
}
