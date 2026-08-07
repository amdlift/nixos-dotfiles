{ self, inputs, ... }:
{
  flake.nixosConfigurations.legion5 = inputs.nixpkgs.lib.nixosSystem {
    modules = [ self.nixosModules.legion5 ];
  };

  flake.modules.nixos.legion5 =
    { pkgs, ... }:
    {
      imports = with self.nixosModules; [
        desktop

        # software this host wants
        btop-cuda
        docker
        foot
        ly
        mango
        rofi
        stylix
        wallpaper
        waybar

        # who lives here
        aaron

        # this machine's own facts
        legion5-hardware
        legion5-monitors
        legion5-nvidia
      ];

      networking.hostName = "legion5";

      # Fixes brightness device
      boot.kernelParams = [ "amdgpu.backlight=0" ];

      environment.systemPackages = with pkgs; [
        abcde
        claude-code
        gh
        git
        nodejs_22
        thunderbird
        vivaldi
        vscodium
        wget
      ];

      nixpkgs.config.allowUnfreePackages = [
        "claude-code"
        "vivaldi"
      ];
    };
}
