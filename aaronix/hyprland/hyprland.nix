{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.settings = {
    monitor = ", 1920x1080@144, 0x0, 1";
    env =
      [
        "LIBVA_DRIVER_NAME,nvidia"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      ];

    exec-once = [
      "nm-applet"
      "blueman-applet"
      "waybar"
      "nvidia-offload hyprpaper"

      # Special Workspaces
      "[workspace special:canvas silent] firefox https://uah.instructure.com"
      "[workspace special:jellyfin silent] env __GLX_VENDOR_LIBRARY_NAME=nvidia jellyfin-desktop"
    ];

    "$mod" = "SUPER";
    bind =
      [
        "$mod, Return, exec, ghostty"
        "$mod, C, killactive"
        "$mod, F, exec, firefox"
        "$mod, D, exec, hyprlauncher"
        ", Print, exec, grimblast copy area"

        # Audio
        ", XF86AudioRaiseVolume, exec, wpctl set-volume 45 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume 45 5%-"
        ", XF86AudioMute, exec, wpctl set-mute 45 toggle"

        # Brightness
        ", XF86MonBrightnessUp, exec, brightnessctl s -d amdgpu_bl2 +10%"
        ", XF86MonBrightnessDown, exec, brightnessctl s -d amdgpu_bl2 10%-"

        # Special Workspaces
        "ALT, C, togglespecialworkspace, canvas"
        "ALT, M, togglespecialworkspace, jellyfin"

        # Dark mode
        "ALT, D, exec, hyprctl hyprpaper wallpaper 'eDP-2, ~/nixos-dotfiles/wallpapers/landscape2_night.png'"

        # Light mode
        "ALT, L, exec, hyprctl hyprpaper wallpaper 'eDP-2, ~/nixos-dotfiles/wallpapers/landscape2_day.png'"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
        builtins.concatLists (builtins.genList (
            x: let
              ws = let
                c = (x + 1) / 10;
              in
                builtins.toString (x + 1 - (c * 10));
            in [
              "$mod, ${ws}, workspace, ${toString (x + 1)}"
              "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]
          )
          10)
      );
    #####################
    ### LOOK AND FEEL ###
    #####################
    
    general = {
      gaps_in = 5;
      gaps_out = 20;

      border_size = 2;

      "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
      "col.inactive_border" = "rgba(595959aa)";

      resize_on_border = false;

      allow_tearing = false;

      layout = "dwindle";
    };

    decoration = {
      rounding = 10;
      rounding_power = 2;
    };

    # Animations
    animations = {
      enabled = true;

      bezier = [
        "overshoot, 0.05, 0.9, 0.1, 1.1"
      ];

      animation = [
        "specialWorkspace, 1, 5, overshoot, slidefadevert 50%"
      ];
    };
  };
}
