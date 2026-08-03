{
  inputs,
  config,
  ...
}:
{
  imports = [
    # declares `flake.modules.<class>.<name>`, the aspect namespace. Any number
    # of files may contribute to one name and the definitions merge, which is
    # what lets one file per aspect exist without a central import list.
    inputs.flake-parts.flakeModules.modules

    # lets `modules` be dropped from the published outputs below
    inputs.flake-parts.flakeModules.touchup

    # adds home-manager options to flake-parts
    inputs.home-manager.flakeModules.home-manager
  ];

  config = {
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    # Republish the aspects under the standard output names, so they are
    # consumable by other flakes and understood by `nix flake check`.
    flake.nixosModules = config.flake.modules.nixos or { };
    flake.homeModules = config.flake.modules.homeManager or { };

    # `modules` is not a flake output the nix CLI knows about; keep it internal
    # rather than have every command warn about it.
    touchup.attr.modules.enable = false;
  };
}
