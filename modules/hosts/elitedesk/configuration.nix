{ self, inputs, ... }:
{
  flake.nixosConfigurations.elitedesk = inputs.nixpkgs.lib.nixosSystem {
    modules = [ self.nixosModules.elitedesk ];
  };

  flake.modules.nixos.elitedesk =
    { pkgs, ... }:
    {
      imports = with self.nixosModules; [
        minimal

        # who lives here
        aaron

        # this machine's own facts
        elitedesk-hardware
      ];

      networking.hostName = "elitedesk";

      environment.systemPackages = with pkgs; [
        git
        wget
      ];
    };
}
