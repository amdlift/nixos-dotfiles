{ self, ... }:
{
  # The two classes diverge completely: NixOS runs the daemon, the Mac only gets
  # a client.
  #
  # Enabling the NixOS half creates the `docker` group, which is what makes
  # `users.users.<name>.extraGroups = [ "docker" ]` resolvable.
  flake.modules.nixos.docker = {
    virtualisation.docker.enable = true;
  };

  # nix-darwin has no `virtualisation.docker`, so this is the CLI client from
  # Homebrew and nothing else — no Docker Desktop, and no daemon. Point it at a
  # host (colima, a remote context, …) or `docker` will have nothing to talk to.
  #
  # Carries its own dependency on the homebrew aspect, so a host only has to
  # import this one.
  flake.modules.darwin.docker = {
    imports = [ self.darwinModules.homebrew ];

    # Not keg-only, so brew links it into the prefix and no `environment.systemPath`
    # entry is needed the way `nodejs` needs one for `node@22`.
    homebrew.brews = [ "docker" ];
  };
}
