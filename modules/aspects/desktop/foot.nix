{
  flake.modules.nixos.foot = {
    home-manager.sharedModules = [ { programs.foot.enable = true; } ];
  };
}
