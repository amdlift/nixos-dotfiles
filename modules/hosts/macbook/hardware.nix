{
  # There is no `nixos-generate-config` equivalent on darwin — macOS owns the
  # disks and boot — so the only machine fact to state is the platform.
  flake.modules.darwin.macbook-hardware = {
    nixpkgs.hostPlatform = "aarch64-darwin";
  };
}
