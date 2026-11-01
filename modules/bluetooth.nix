{
  den.aspects.bluetooth = {
    nixos.hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
    
    provides.blueman.nixos.services.blueman.enable = true;
  };
}