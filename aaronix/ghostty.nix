{ config, pkgs, ... }:

{
  programs.ghostty.enable = true;
  programs.ghostty.settings = {
    background-opacity = 0.5;
    background-blur = 20;
  };
}