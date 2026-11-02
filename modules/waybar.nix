{
  flake-file.inputs.waybar = {
    url = "github:alexays/waybar";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
