{ config, pkgs, ... }:

{
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./hyprpaper.nix
    ./hyprlock.nix
    ./ghostty.nix
    ./hyprlauncher.nix
    ./hypridle.nix
    ./yazi.nix
  ];

  home.username = "aaron";
  home.homeDirectory = "/home/aaron";
  home.stateVersion = "25.11";

  home.packages = [
    pkgs.steam-tui
    pkgs.git
  ];

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };
}
