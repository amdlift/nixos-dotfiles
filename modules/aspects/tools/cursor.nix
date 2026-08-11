{ self, ... }:
{
  # Cursor from Homebrew rather than nixpkgs. Carries its own dependency on the
  # homebrew aspect, so a host only has to import this one.
  flake.modules.darwin.cursor = {
    imports = [ self.darwinModules.homebrew ];

    homebrew.casks = [ "cursor" ];
  };
}
