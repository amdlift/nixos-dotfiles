{
  den.aspects.otbr.nixos = {
    services.openthread-border-router = {
      enable = true;
      backboneInterfaces = [ "eno1" ];
    };
  };
}
