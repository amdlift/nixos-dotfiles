{
  den.aspects.danya._.calibre.nixos = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.calibre ]; # provides calibredb for the import

    services.calibre-server = {
      enable = true;
      libraries = [ "/zfspool/media/CalibreLibrary" ];
      host = "0.0.0.0";
      port = 8090;
      openFirewall = true;
      group = "media";
    };

    services.calibre-web = {
      enable = true;
      group = "media";
      listen.ip = "0.0.0.0";
      listen.port = 8083;
      openFirewall = true;
      options = {
        calibreLibrary = "/zfspool/media/CalibreLibrary";
        enableBookUploading = true;
        enableKepubify = true;
      };
    };
  };
}
