let
  # The home side is class-agnostic and always a release string.
  home = { home.stateVersion = "25.11"; };
in
{
  # One aspect owning every half of the same fact. Don't bump these.
  #
  # The system halves are not interchangeable: NixOS takes a release string
  # while nix-darwin takes an integer (`types.ints.between 1 maxStateVersion`,
  # currently 7), which is exactly the kind of divergence a per-class aspect
  # exists to absorb.
  flake.modules.nixos.state-version = {
    system.stateVersion = "25.11";
    home-manager.sharedModules = [ home ];
  };

  flake.modules.darwin.state-version = {
    system.stateVersion = 7;
    home-manager.sharedModules = [ home ];
  };
}
