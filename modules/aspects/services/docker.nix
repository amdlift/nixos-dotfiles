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

  # nix-darwin has no `virtualisation.docker`, so the Mac gets Docker Desktop,
  # which supplies both the VM running the daemon and the client.
  #
  # Carries its own dependency on the homebrew aspect, so a host only has to
  # import this one.
  flake.modules.darwin.docker = {
    imports = [ self.darwinModules.homebrew ];

    # The cask, not the `docker` formula: Desktop bundles its own client and
    # symlinks it into /usr/local/bin, so installing both would leave two
    # installations contending for the same `docker` binary.
    #
    # /usr/local/bin is already on the default PATH, so unlike `nodejs` and its
    # keg-only `node@22` this needs no `environment.systemPath` entry.
    #
    # Desktop is unfree, but that is Homebrew's concern rather than nixpkgs' —
    # no `allowUnfreePackages` entry applies. First launch installs a privileged
    # helper and asks for an admin password; nothing here can pre-empt that.
    homebrew.casks = [ "docker-desktop" ];
  };
}
