{ self, ... }:
{
  flake.modules.nixos.desktop = {
    imports = with self.nixosModules; [
      minimal

      audio
      bluetooth
    ];

    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };
  };
}
