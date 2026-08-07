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

        # software this host wants
        btop-cuda
        flatpak

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

      # This host's own flatpaks, independent of any other host's.
      services.flatpak.packages = [ ];
    };
}
