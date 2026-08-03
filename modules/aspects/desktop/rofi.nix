{
  # Kept as a plain package: nothing configures rofi yet, and mango's launcher
  # bind only needs the binary on PATH. Promote to `programs.rofi` (and let
  # stylix theme it) once there is user configuration to hang off it.
  flake.modules.nixos.rofi =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.rofi ];
    };
}
