{ config, pkgs, ... }:

{
  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      wallpaper = {
        monitor = "eDP-2";
        path = "~/nixos-dotfiles/hyprpaper/wallpapers/landscape2_day.png";
      };
    };
  };
}