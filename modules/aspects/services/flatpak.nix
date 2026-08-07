{ inputs, ... }:
{
  # Linux-only: flatpak has no darwin counterpart, so no `darwin` attribute is
  # defined and the Mac cannot import this by mistake.
  #
  # nixpkgs' own `services.flatpak` declares only `enable` and `package` — it
  # installs flatpak but manages no apps. nix-flatpak extends the *same* option
  # namespace with `packages`, `remotes`, `update` and `overrides`, which is what
  # makes the app list declarative.
  #
  # A host declares what it wants, the same way it does with systemPackages:
  #
  #   services.flatpak.packages = [
  #     "com.brave.Browser"                                   # from the default remote
  #     { appId = "com.obsproject.Studio"; origin = "flathub"; }
  #   ];
  #
  # `remotes` already defaults to flathub, so nothing needs declaring for it.
  flake.modules.nixos.flatpak =
    { lib, pkgs, ... }:
    {
      imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

      services.flatpak.enable = true;

      # Leave anything installed by hand alone. Setting this true makes the flake
      # the sole owner of flatpak state and uninstalls every package *and remote*
      # not declared here on the next activation.
      services.flatpak.uninstallUnmanaged = false;

      # nixpkgs asserts that flatpak has portals ("To use Flatpak you must enable
      # XDG Desktop Portals with xdg.portal.enable"), so the aspect carries them
      # rather than relying on a desktop happening to provide them — on legion5
      # mango already does, but elitedesk has no window manager at all.
      xdg.portal.enable = true;
      xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

      # Since xdg-desktop-portal 1.17, enabling portals without saying which
      # backend serves which interface warns. Name the backend this aspect
      # itself ships as the fallback, rather than the `"*"` escape hatch that
      # just picks the first implementation lexicographically.
      #
      # This is only the `common` fallback section, used when no desktop-specific
      # section matches. legion5 is unaffected: mango contributes its own
      # `config.mango` (plus `configPackages`), which wins under a mango session.
      xdg.portal.config.common.default = lib.mkDefault [ "gtk" ];
    };
}
