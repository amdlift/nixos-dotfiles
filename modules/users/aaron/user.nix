{ self, ... }:
{
  # The user as an entity: a host imports this to say "aaron exists here".
  # What aaron's software does is in the sibling files; what software exists at
  # all is decided by the aspects the host imports.
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
}
