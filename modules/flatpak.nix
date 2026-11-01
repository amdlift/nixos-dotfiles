{ inputs, ... }: {
  flake-file.inputs.nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

  den.aspects.flatpak.nixos = {
    imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

    services.flatpak = {
      enable = true;
      update.auto = {
        enable = true;
        onCalendar = "weekly";
      };
      # remove flatpaks you install by hand that aren't listed here:
      # uninstallUnmanaged = true;
    };
  };
}