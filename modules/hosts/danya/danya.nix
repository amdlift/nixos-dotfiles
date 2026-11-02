{ den, ... }: {
  den.aspects.danya = {
    includes = with den.aspects; [
      bluetooth
      flatpak
      network-manager
      nvidia
      podman
      ssh
      systemd-boot
      unstable
      usb

      danya._.nixarr
      danya._.zfs

      (den._.unfree [ "claude-code" "cuda_cccl" "cuda_cudart" "cuda_nvcc" "libcublas" ])
    ];

    nixos.imports = [ ./_hardware.nix ];
  };
}