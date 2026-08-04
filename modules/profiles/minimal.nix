{ self, ... }:
{
  # "The baseline for this class." The two lists diverge because bootloaders,
  # NetworkManager, sshd and i18n have no nix-darwin counterpart — macOS
  # provides those itself.
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

  flake.modules.darwin.minimal.imports = with self.darwinModules; [
    bash
    home-manager
    nix-settings
    state-version
  ];
}
