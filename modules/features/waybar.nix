{
  flake.nixosModules.waybar = {
    home-manager.sharedModules = [
      { programs.waybar.enable = true; }
    ];
  };
}