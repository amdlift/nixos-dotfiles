{ self, ... }:
{
  flake.modules.homeManager.aaron = {
    # Brings omniwm's option declarations in without enabling it, so everything
    # below is inert on a host that doesn't import the omniwm aspect.
    imports = [ self.homeModules.omniwm ];

    # The whole settings file is vendored rather than written as an attrset,
    # because OmniWM's config is one 15KB document — 153 hotkeys, app rules,
    # borders, gaps, workspaces — and `settings` is rendered *wholesale*.
    # Declaring a handful of keys here would not merge with the rest; it would
    # replace it, resetting everything unstated to OmniWM's defaults.
    #
    # `settings` takes `either path tomlFormat.type`, so a path is passed
    # through verbatim instead of being serialized.
    #
    # Caveat that comes with owning the file this way: OmniWM rewrites its own
    # settings at runtime (that is how this copy was obtained). Changes made in
    # the GUI land in a file that the next activation replaces, so they have to
    # be copied back here to survive. `general.updateChecksEnabled = false` is
    # in the vendored file, keeping the built-in updater out of nix's way.
    programs.omniwm.settings = ./omniwm-settings.toml;
  };
}
