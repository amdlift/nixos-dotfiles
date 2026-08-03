{ self, ... }: {
  flake.nixosModules.desktop = {
    imports = [
      self.nixosModules.minimal

      self.nixosModules.bluetooth
      self.nixosModules.pipewire
    ];

    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };
  };
}