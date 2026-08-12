{
  flake.modules.nixos.usb = {
    services.udisks2.enable = true;
  };
}
