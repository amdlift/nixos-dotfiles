{
  den.aspects.otbr.nixos = { lib, ... }: {
    services.openthread-border-router = {
      enable = true;
      backboneInterfaces = [ "eno1" ];

      radio = {
        device = "/dev/serial/by-id//usb-Nabu_Casa_ZBT-2_E072A1DC1660-if00";
        baudRate = 460800; # This and flow control are hardware dependant
        flowControl = false; # check your device's documentation
      };

      rest = {
        listenAddress = "::";
        listenPort = 8081;
      };

      web = {
        enable = true;
      };
    };

    boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = lib.mkForce 1;
  };
}
