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
