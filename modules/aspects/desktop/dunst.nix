{
  # Enablement only. Appearance comes from stylix's dunst target, and no
  # autostart line is needed: the unit is D-Bus activated and mango exports
  # WAYLAND_DISPLAY into the user bus before reaching graphical-session.target.
  flake.modules.nixos.dunst =
    { pkgs, ... }:
    {
      home-manager.sharedModules = [ { services.dunst.enable = true; } ];

      environment.systemPackages = [ pkgs.libnotify ];
    };
}
