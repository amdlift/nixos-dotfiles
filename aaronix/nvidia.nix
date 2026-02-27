{ config, pkgs, ... }:

{
  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };

    nvidiaBusId = "PCI:1:0:0";
    amdgpuBusId = "PCI:6:0:0";
  };

  services.thermald.enable = pkgs.lib.mkDefault true;
}