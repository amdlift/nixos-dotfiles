{
  # The one place mango and stylix meet: stylix owns the image, mango starts the
  # thing that draws it. Reading `config.stylix.image` here (NixOS level, where
  # the stylix aspect is imported by the same host) keeps stylix the single
  # source of truth and avoids depending on the repo's checkout path.
  flake.modules.nixos.wallpaper =
    { config, ... }:
    {
      home-manager.sharedModules = [
        {
          wayland.windowManager.mango.autostart_sh = ''
            swaybg -i ${config.stylix.image} -m fill &
          '';
        }
      ];
    };
}
