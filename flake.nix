# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  inputs = {
    agenix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:ryantm/agenix";
    };
    den.url = "github:denful/den";
    flake-file.url = "github:vic/flake-file";
    flake-parts = {
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
      url = "github:hercules-ci/flake-parts";
    };
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/release-26.05";
    };
    import-tree.url = "github:vic/import-tree";
    mangowm = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:mangowm/mango";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    nixarr.url = "github:nix-media-server/nixarr";
    nixcord.url = "github:4evy/nixcord";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-lib.follows = "nixpkgs";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvf = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:NotAShelf/nvf";
    };
    stylix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/stylix/release-26.05";
    };
    treefmt-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:numtide/treefmt-nix";
    };
    waybar = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:alexays/waybar";
    };
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

}
