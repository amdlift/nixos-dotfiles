{
  flake.modules.nixos.audio = {
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # jack.enable = true;

      # Already the default, but stated so `wpctl` — which aaron's volume binds
      # reach for — is a dependency of this aspect rather than a happy accident.
      wireplumber.enable = true;
    };
  };
}
