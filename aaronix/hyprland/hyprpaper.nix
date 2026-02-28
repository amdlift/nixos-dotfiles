{ config, pkgs, ... }:

{
  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      wallpaper = {
        monitor = "";
        path = "~/nixos-dotfiles/aaronix/wallpapers/landscape2_day.png";
      };
    };
  };
}