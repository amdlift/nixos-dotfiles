{ inputs, ... }: {
  flake-file.inputs = {
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
  };

  den.aspects.minecraft-server = {
    nixos = {
      imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
      nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

      services.minecraft-servers = {
        enable = true;
        eula = true;
        openFirewall = true;
      };
    };
  };
}
