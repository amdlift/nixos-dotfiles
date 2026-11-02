{ den, ... }: {
  # host aspect
  den.aspects.legion5 = {
    # host NixOS configuration
    includes = with den.aspects; [
      bluetooth
      bluetooth._.blueman
      flatpak
      gaming
      ly
      mango
      network-manager
      nvidia
      pipewire
      podman
      ssh
      stylix
      systemd-boot
      unstable
      usb
      zen-browser

      (den._.unfree [
        "claude-code"
        "cuda_cccl"
        "cuda_cudart"
        "cuda_nvcc"
        "libcublas"
      ])
    ];

    provides.aaron.user.extraGroups = [ "dialout" ];

    nixos = { pkgs, ... }: {
      imports = [ ./_hardware.nix ];

      nix.settings.trusted-users = [ "aaron" ];

      # Host packages
      environment.systemPackages = with pkgs; [
        blender
        brightnessctl
        btop-cuda
        claude-code
        eden
        gh
        glab
        grim
        jq
        ollama-cuda
        podman-compose
        ranger
        rofi
        slurp
        thunderbird
        vscodium
        whipper

        unstable.kdePackages.plasma-bigscreen
        unstable.lightcraft
        unstable.photocraft
      ];

      services.flatpak.packages = [
        "org.vinegarhq.Sober"
      ];

      services.displayManager = {
        sessionPackages = [ pkgs.unstable.kdePackages.plasma-bigscreen ];
      };

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

      # Configure keymap in X11
      services.xserver.xkb = {
        layout = "us";
        variant = "";
      };

      # Nvidia config
      services.xserver.videoDrivers = [ "amdgpu" ];
      hardware.nvidia.prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        nvidiaBusId = "PCI:1@0:0:0";
        amdgpuBusId = "PCI:5@0:0:0";
      };

      # Fix screen brightness issue on Legion 5
      boot.kernelParams = [ "amdgpu.backlight=0" ];
    };
  };
}
