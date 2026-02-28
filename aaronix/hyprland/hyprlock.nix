{ config, pkgs, ... }:

{
  programs.hyprlock.enable = true;
  programs.hyprlock.settings = {
    general = {
      hide_cursor = true;
      ignore_empty_input = true;
    };
    
    # Animations
    animations = {
      enabled = true;
      fade_in = {
        duration = 300;
        bezier = "easeOutQuint";
      };
      fade_out = {
        duration = 300;
        bezier = "easeOutQuint";
      };
    };

    # Background
    background = [
      {
        path = "screenshot";
        blur_passes = 3;
        blur_size = 8;
      }
    ];

    # Password Input
    input-field = [
      {
        size = "200, 50";
        position = "0, -80";
        monitor = "";
        dots_center = true;
        fade_on_empty = false;
        font_color = "rgb(202, 211, 245)";
        inner_color = "rgb(91, 96, 120)";
        outer_color = "rgb(24, 25, 38)";
        outline_thickness = 5;
        placeholder_text = ''<span foreground="##cad3f5">Password...</span>'';
        shadow_passes = 2;
      }
    ];

    # Clock
    label = [
      {
        text = "$TIME";
        color = "rgba(254, 254, 254, 1.0)";
        font_size = 40;
        font_family = "JetBrainsMono Nerd Font";
        position = "0, 80";
        halign = "center";
        valign = "center";
      }
    ];

  };
}