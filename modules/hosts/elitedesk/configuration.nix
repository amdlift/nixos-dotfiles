{ self, inputs, ... }: {
  flake.nixosConfigurations.elitedesk = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.elitedeskModule
      self.nixosModules.elitedeskHardware
      self.nixosModules.myHomeManager
    ];
  };

  flake.nixosModules.elitedeskModule = { pkgs, ... }: {
    imports = [
      self.nixosModules.minimal
    ];

    environment.systemPackages = with pkgs; [
      git
      wget
    ];

    users.users.aaron = {
      isNormalUser = true;
      shell = pkgs.bash;
      extraGroups = [ "networkmanager" "wheel" "docker" "dialout" ];
    };
    home-manager.users.aaron = self.homeModules.aaronModule;
  };

}