{ self, inputs, ... }:
{
  flake.darwinConfigurations.aarons-macbook = inputs.nix-darwin.lib.darwinSystem {
    modules = [ self.darwinModules.aarons-macbook ];
  };

  flake.modules.darwin.aarons-macbook = { pkgs, ... }: {
    imports = with self.darwinModules; [
      minimal

      # software this host wants
      btop
      nodejs
      displaylink

      # who lives here
      aaron

      # this machine's own facts
      aarons-macbook-hardware
    ];

    networking.hostName = "aarons-macbook";

    environment.systemPackages = with pkgs; [
      awscli2
      claude-code
      gh
      logseq
      aws-cdk-cli
      ripgrep
      vscodium
    ];

    nixpkgs.config.allowUnfreePackages = [
      "claude-code"
    ];

    nixpkgs.config.permittedInsecurePackages = [
      "electron-39.8.10"
    ];

    system.defaults.NSGlobalDomain.AppleInterfaceStyle = "Dark";
  };
}
