{ inputs, ... }:
let
  # identical on both classes; only the entrypoint module differs
  settings = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      # Rename a file that is in the way instead of aborting activation. The
      # dot is added by home-manager itself (`$targetPath.$HOME_MANAGER_BACKUP_EXT`),
      # so this is "bak", not ".bak", which would produce `foo..bak`.
      #
      # `overwriteBackup` is left off, so a second collision on the same path
      # still fails rather than silently discarding the first backup.
      backupFileExtension = "bak";
    };
  };
in
{
  flake.modules.nixos.home-manager.imports = [
    inputs.home-manager.nixosModules.default
    settings
  ];

  flake.modules.darwin.home-manager.imports = [
    inputs.home-manager.darwinModules.default
    settings
  ];
}
