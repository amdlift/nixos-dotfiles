{ self, ... }:
{
  # The user as an entity: a host imports this to say "aaron exists here".
  # What aaron's software does is in the sibling files; what software exists at
  # all is decided by the aspects the host imports. Both classes hand the same
  # `homeModules.aaron` to home-manager, so his configuration follows him.
  flake.modules.nixos.aaron =
    { pkgs, ... }:
    {
      users.users.aaron = {
        isNormalUser = true;
        shell = pkgs.bash;
        extraGroups = [
          "networkmanager"
          "wheel"
          "docker"
          "dialout"
        ];
      };

      home-manager.users.aaron = self.homeModules.aaron;
    };

  # macOS owns the account itself, so this only tells nix-darwin where the home
  # lives and which user the system-level activation acts on.
  flake.modules.darwin.aaron = {
    users.users.aaron.home = "/Users/aaron";
    system.primaryUser = "aaron";

    home-manager.users.aaron = self.homeModules.aaron;
  };
}
