{ den, ... }: {
  den.aspects.nvidia = {
    includes = [
      (den._.unfree [ "nvidia-x11" "nvidia-settings" ])
    ];

    nixos = {
      hardware.graphics.enable = true;
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.nvidia.open = true;
    };
  };
}