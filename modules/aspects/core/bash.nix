{
  # Enablement only. Aliases, prompt and the rest belong to the user.
  flake.modules.nixos.bash = {
    home-manager.sharedModules = [ { programs.bash.enable = true; } ];
  };
}
