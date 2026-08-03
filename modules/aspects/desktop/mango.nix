{ inputs, ... }:
{
  flake.modules.nixos.mango =
    { pkgs, ... }:
    {
      imports = [ inputs.mangowm.nixosModules.mango ];

      programs.mango.enable = true;

      # The compositor's binds and autostart reach for these, so the aspect
      # carries them rather than relying on a host's package list.
      environment.systemPackages = with pkgs; [
        brightnessctl
        swaybg
      ];

      home-manager.sharedModules = [ { wayland.windowManager.mango.enable = true; } ];
    };

  # Option declarations only, no `enable`. A user module that configures mango
  # imports this so that its settings are inert on a host without the mango
  # aspect, rather than an eval error about undeclared options.
  flake.modules.homeManager.mango.imports = [ inputs.mangowm.hmModules.mango ];
}
