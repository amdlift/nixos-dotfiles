{ self, ... }:
{
  # Node 22 from Homebrew rather than nixpkgs. Carries its own dependency on the
  # homebrew aspect, so a host only has to import this one.
  flake.modules.darwin.displaylink =
    { config, ... }:
    {
      imports = [ self.darwinModules.homebrew ];

      homebrew.casks = [ "displaylink" ];

      # `node@22` is a versioned, keg-only formula: Homebrew deliberately does
      # not link it into the prefix (with `link = null` it actively *unlinks* a
      # linked keg-only formula), so the keg's own bin directory has to go on
      # PATH for `node` and `npm` to resolve.
    };
}
