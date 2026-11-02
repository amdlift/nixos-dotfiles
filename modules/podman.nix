{
  den.aspects.podman.nixos = { host, lib, ... }: {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true; # Creates a symlink from docker to podman
      defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
    };

    users.users = lib.genAttrs (builtins.attrNames host.users) (_: {
      extraGroups = [ "podman" ];
    });
  };
}
