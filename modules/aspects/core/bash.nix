let
  # Enablement only. Aliases, prompt and the rest belong to the user.
  shared = {
    home-manager.sharedModules = [ { programs.bash.enable = true; } ];
  };
in
{
  flake.modules.nixos.bash = shared;
  flake.modules.darwin.bash = shared;
}
