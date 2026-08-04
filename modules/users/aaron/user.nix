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

  # macOS owns the account itself (SSO-managed) and its login name is
  # `aaron.davis`, which cannot be changed. Only the entity layer knows that:
  # home-manager derives `home.username` from `users.users.<name>.name` and
  # `home.homeDirectory` from `users.users.<name>.home`, so keying it under the
  # macOS account while handing it the same class-agnostic `homeModules.aaron`
  # makes the two accounts one user as far as his configuration is concerned.
  flake.modules.darwin.aaron =
    let
      # dotted string is a single attribute name, not a nested path
      account = "aaron.davis";
    in
    {
      users.users.${account}.home = "/Users/${account}";
      system.primaryUser = account;

      home-manager.users.${account} = self.homeModules.aaron;
    };
}
