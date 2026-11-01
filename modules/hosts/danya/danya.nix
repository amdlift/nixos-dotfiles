{ den, ... }: {
  den.aspects.danya = {
    includes = with den.aspects; [
      nixarr
      systemd-boot
    ];

    nixos.imports = [ ./_hardware.nix ];
  };
}