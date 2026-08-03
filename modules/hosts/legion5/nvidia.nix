{
  flake.modules.nixos.legion5-nvidia = {
    nixpkgs.config.allowUnfreePackages = [
      "nvidia-x11"
      "nvidia-settings"
      "nvidia-persistenced"
    ];

    hardware.graphics.enable = true;
    services.xserver.videoDrivers = [
      "amdgpu"
      "nvidia"
    ];
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
