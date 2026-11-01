{ inputs, ... }: {
  flake-file.inputs = {
    stylix = {
      url = "github:nix-community/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.stylix.nixos = { lib, pkgs, ... }: {
    imports = [ inputs.stylix.nixosModules.stylix ];

    stylix = {
      enable = true;
      polarity = "dark";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
      image = lib.mkDefault (inputs.self + "/wallpapers/nixos-gruvbox-dark-medium.png");

      opacity.terminal = 0.9;

      fonts = {
        monospace = { package = pkgs.nerd-fonts.jetbrains-mono; name = "JetBrainsMono Nerd Font"; };
        sansSerif = { package = pkgs.dejavu_fonts; name = "DejaVu Sans"; };
        serif     = { package = pkgs.dejavu_fonts; name = "DejaVu Serif"; };

        sizes = {
          popups = 13;
          terminal = 14;
        };
      };

      cursor = { package = pkgs.bibata-cursors; name = "Bibata-Modern-Classic"; size = 24; };
    };
  };
}
