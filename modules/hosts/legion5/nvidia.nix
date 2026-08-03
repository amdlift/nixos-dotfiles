{ lib, ... }: {
  flake.nixosModules.legion5Nvidia = {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
      "nvidia-persistenced"
    ];

    hardware.graphics.enable = true;
    services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];
    hardware.nvidia.open = true;

    hardware.nvidia.prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      nvidiaBusId = "PCI:1@0:0:0";
      amdgpuBusId = "PCI:5@0:0:0";
    };
  };
}