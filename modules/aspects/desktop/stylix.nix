{ inputs, ... }:
{
  flake.modules.nixos.stylix =
    { pkgs, ... }:
    {
      imports = [ inputs.stylix.nixosModules.stylix ];

      stylix = {
        enable = true;
        image = ../../../wallpapers/wallhaven-mountain1.jpg;

        base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";

        opacity.terminal = 0.9;

        fonts = {
          serif = {
            package = pkgs.dejavu_fonts;
            name = "DejaVu Serif";
          };

          sansSerif = {
            package = pkgs.dejavu_fonts;
            name = "DejaVu Sans";
          };

          monospace = {
            package = pkgs.nerd-fonts.jetbrains-mono;
            name = "JetBrainsMono Nerd Font";
          };

          sizes.terminal = 14;
        };
      };
    };
}
