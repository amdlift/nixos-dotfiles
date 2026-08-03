{ self, ... }:
{
  flake.modules.nixos.minimal.imports = with self.nixosModules; [
    bash
    bootloader
    home-manager
    locale
    networking
    nix-settings
    ssh
    state-version
  ];
}
