{
  den.aspects.danya._.zfs.nixos = {
    boot.supportedFilesystems = [ "zfs" ];
    boot.zfs.forceImportRoot = false;
    boot.zfs.extraPools = [ "zfspool" ];
    networking.hostId = "25d39607";
  };
}
