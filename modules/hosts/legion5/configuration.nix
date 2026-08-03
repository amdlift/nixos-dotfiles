{ lib, self, inputs, ... }: {
  flake.nixosConfigurations.legion5 = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.legion5Module
      self.nixosModules.legion5Hardware
      self.nixosModules.legion5Nvidia
      self.nixosModules.myHomeManager
    ];
  };

  flake.nixosModules.legion5Module = { pkgs, ... }: {
    imports = [
      self.nixosModules.desktop
      self.nixosModules.ly
      self.nixosModules.mango
      self.nixosModules.stylix
      self.nixosModules.waybar
    ];

    # Fixes brightness device
    boot.kernelParams = [
      "amdgpu.backlight=0"
    ];

    networking.hostName = "legion5";

    environment.systemPackages = with pkgs; [
      abcde
      brightnessctl
      btop-cuda
      claude-code
      foot
      git
      rofi
      swaybg
      thunderbird
      vivaldi
      vscodium
      wget
    ];

    nixpkgs.config.allowUnfreePackages = [
      "claude-code"
      "vivaldi"
    ];

    users.users.aaron = {
      isNormalUser = true;
      shell = pkgs.bash;
      extraGroups = [ "networkmanager" "wheel" "docker" "dialout" ];
      packages = with pkgs; [];
    };

    home-manager.users.aaron = self.homeModules.aaronModule;
  };

}
