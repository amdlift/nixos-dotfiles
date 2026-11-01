# defines all hosts + users + homes.
# then config their aspects in as many files you want
{
  # legion5 host
  den.hosts.x86_64-linux.legion5 = {
    roles = [ "desktop" ];
    users.aaron = { };
  };

  # danya host
  den.hosts.x86_64-linux.danya = {
    roles = [ "server" ];
    users.aaron = { };
  };

  # define an standalone home-manager for tux
  # den.homes.x86_64-linux.tux = { };

  # be sure to add nix-darwin input for this:
  # den.hosts.aarch64-darwin.apple.users.alice = { };

  # other hosts can also have user tux.
  # den.hosts.x86_64-linux.south = {
  #   wsl = { }; # add nixos-wsl input for this.
  #   users.tux = { };
  #   users.orca = { };
  # };
}
