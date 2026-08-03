{
  # Enablement only. The bar's layout and modules belong to the user;
  # its colours and fonts come from stylix.
  flake.modules.nixos.waybar = {
    home-manager.sharedModules = [ { programs.waybar.enable = true; } ];
  };
}
