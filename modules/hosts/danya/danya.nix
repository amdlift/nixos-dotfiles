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

      danya._.immich
      danya._.nixarr
      danya._.zfs

      (den._.unfree [
        "claude-code"
        "cuda_cccl"
        "cuda_cudart"
        "cuda_nvcc"
        "libcublas"
      ])
    ];

    nixos = { pkgs, ... }: {
      imports = [ ./_hardware.nix ];

      nix.settings.trusted-users = [ "aaron" ];

      environment.systemPackages = with pkgs; [
        zfs
      ];

      time.timeZone = "America/Chicago";

      i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
      };

      hardware.nvidia.open = false;
      hardware.nvidia.branch = "legacy_580";
    };
  };
}
