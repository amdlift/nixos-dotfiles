{ config, pkgs, ... }:

{
  programs.waybar.enable = true;
  programs.waybar.settings.main = {
    layer = "top";
    margin-top = 10;
    modules-center = [ "clock" "hyprland/workspaces" "wireplumber" "backlight" "tray" "battery" ];

    "hyprland/workspaces" = {
      format = "{name}";
      persistent-workspaces = {
        "*" = 5;
      };
    };

    "wireplumber" = {
      format = "{icon}";
      tooltip = true;
      tooltip-format = "{volume}%";
      format-muted = "";
      on-click = "pwvucontrol";
      format-icons = [ "" "" "" ];
    };

    "backlight" = {
      device = "amdgpu_bl2";
      format = "{icon}";
      tooltip = true;
      format-alt = "<small>{percent}%</small>";
      format-icons = [ "󱩎" "󱩏" "󱩐" "󱩑" "󱩒" "󱩓" "󱩔" "󱩕" "󱩖" "󰛨" ];
      on-scroll-up = "brightnessctl s -d amdgpu_bl2 1%+";
      on-scroll-down = "brightnessctl s -d amdgpu_bl2 1%-";
      smooth-scrolling-threshold = "2400";
      tooltip-format = "Brightness {percent}%";
    };

    "tray" = {
      icon-size = 20;
      spacing = 10;
    };

    "battery" = {
      format = "{icon}";
      tooltip = true;
      format-alt = "{icon}  {capacity}%";
      tooltip-format = "{timeTo}";
      format-icons = [ "" "" "" "" "" ];
    };
  };
  
  programs.waybar.style = 
    ''
      * {
        border: none;
        border-radius: 0;
        font-size: 16px;
        min-height: 24px;
      }
      window#waybar {
        background: transparent;
      }
      #clock {
        border-radius: 26px 0 0 26px;
        padding-left: 20px;
        padding-right: 10px;
      }
      #wireplumber {
        padding: 10px;
      }
      #backlight {
        padding: 10px;
      }
      #tray {
        padding: 10px;
      }
      #battery {
        border-radius: 0 26px 26px 0;
        padding-left: 10px;
        padding-right: 20px;
      }
      #clock,
      #wireplumber,
      #backlight,
      #tray,
      #battery {
        background: #282a36;
        color: #f8f8f2;
      }
      #workspaces button {
        background-color: #282a36;
        color: #f8f8f2;
      }
      #workspaces button:hover {
        background-color: #44475a;
      }
      #workspaces button.active {
        background-color: #f8f8f2;
        color: #282a36;
      }
    '';
}