{
  flake.homeModules.aaronWaybar = {
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

      "mango/workspaces" = {
        format = "{icon}";
        format-icons = {
          active = "";
          default = "";
          urgent = "";
          empty = "";
        };
        
        on-click = "activate";
        on-click-right = "toggle";
        overview-label = "";
      };
    };
  };
}