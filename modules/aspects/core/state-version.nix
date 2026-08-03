{
  # One aspect owning both halves of the same fact. Don't bump these.
  flake.modules.nixos.state-version = {
    system.stateVersion = "25.11";

    home-manager.sharedModules = [ { home.stateVersion = "25.11"; } ];
  };
}
