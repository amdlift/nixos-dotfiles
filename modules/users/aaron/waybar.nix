{
  flake.modules.homeManager.aaron = {
    programs.waybar.settings.main = {
      layer = "top";
      position = "top";
      height = 30;
      spacing = 4;

      modules-left = [
        "mango/workspaces"
        "mango/layout"
      ];

      modules-center = [
        "clock"
      ];

      modules-right = [
        "pulseaudio"
        "network"
        "battery"
      ];

      # Geometric shapes rather than Nerd Font private-use glyphs: an empty
      # string here is truthy to jsoncpp, so a stripped codepoint silently
      # short-circuits getIcon's fallbacks and renders a blank bar.
      "mango/workspaces" = {
        format = "{icon}";
        format-icons = {
          active = "●";
          default = "○";
          urgent = "◉";
          empty = "·";
        };

        on-click = "activate";
        on-click-right = "toggle";
      };

      # Follows the default sink, so it tracks whichever output is active.
      # Glyphs are BMP for the same reason as the workspace pips above.
      "pulseaudio" = {
        format = "{icon} {volume}%";
        format-muted = "✕ {volume}%";
        format-icons = {
          headphone = "♫";
          headset = "♫";
          default = "♪";
        };

        tooltip-format = "{desc}";
        scroll-step = 5;
        max-volume = 100;
        on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      };
    };

    # Stylix styles these buttons but sets no metrics, so without padding they
    # collapse to their border.
    programs.waybar.style = ''
      #workspaces button {
        padding: 0 4px;
      }
    '';
  };
}
