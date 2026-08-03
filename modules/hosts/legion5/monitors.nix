{
  # Facts about this laptop's panels and backlight, kept out of the mango aspect
  # and out of aaron's config so both stay portable.
  flake.modules.nixos.legion5-monitors = {
    home-manager.sharedModules = [
      {
        wayland.windowManager.mango.settings = {
          monitorrule = [
            "name:^eDP-2$,width:1920,height:1080,refresh:144,x:0,y:0"
            "name:^HDMI-A-1$,width:3840,height:2160,refresh:30,x:1920,y:0"
          ];

          bind = [
            "NONE,XF86MonBrightnessUp,spawn,brightnessctl -d amdgpu_bl2 s +5%"
            "NONE,XF86MonBrightnessDown,spawn,brightnessctl -d amdgpu_bl2 s 5%-"
          ];
        };
      }
    ];
  };
}
