{
  # NixOS-only: nix-darwin has no `virtualisation.docker`, so no darwin
  # attribute is defined and a Mac cannot import this by mistake.
  #
  # Enabling this creates the `docker` group, which is what makes
  # `users.users.<name>.extraGroups = [ "docker" ]` resolvable.
  flake.modules.nixos.docker = {
    virtualisation.docker.enable = true;
  };
}
