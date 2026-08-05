{ self, ... }:
{
  flake.modules.homeManager.aaron = {
    # Brings omniwm's option declarations in without enabling it, so everything
    # below is inert on a host that doesn't import the omniwm aspect.
    imports = [ self.homeModules.omniwm ];

    # Nix owns the app, so the built-in updater should stay out of the way.
    # Keybinds and layout go here too — see OmniWM's docs for the keys.
    programs.omniwm.settings = {
      general.updateChecksEnabled = false;
    };
  };
}
