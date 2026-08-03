{ self, inputs, ... }: {
  flake.homeModules.aaronModule = { pkgs, ... }: {
    imports = [
      self.homeModules.aaronWaybar
    ];

    programs.bash.enable = true;
    programs.bash.shellAliases.ll = "ls -l";

    programs.foot.enable = true;

    home.stateVersion = "25.11";
  };
}