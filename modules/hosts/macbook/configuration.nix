{ self, inputs, ... }:
{
  flake.darwinConfigurations.macbook = inputs.nix-darwin.lib.darwinSystem {
    modules = [ self.darwinModules.macbook ];
  };

  flake.modules.darwin.macbook = {
    imports = with self.darwinModules; [
      minimal

      # software this host wants
      btop

      # who lives here
      aaron

      # this machine's own facts
      macbook-hardware
    ];

    networking.hostName = "macbook";
  };
}
