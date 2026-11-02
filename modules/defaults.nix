{ lib, den, ... }:
{
  den.default.nixos.system.stateVersion = "25.11";
  den.default.homeManager.home.stateVersion = "25.11";

  # enable hm by default
  den.schema.user.classes = lib.mkDefault [ "homeManager" ];

  # Backup extension when home-manager overwrites manual dotfiles
  den.default.nixos.home-manager.backupFileExtension = "backup";

  # Enable flakes on every host
  den.default.nixos.nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Names the networking hostname of each host after its host aspect
  den.schema.host.includes = [ den.batteries.hostname ];
}
