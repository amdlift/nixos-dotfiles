{
  # OmniWM, a Niri/Hyprland-inspired macOS tiling compositor. darwin-only, so no
  # `nixos` attribute exists and a NixOS host cannot import it by mistake.
  #
  # Option declarations only, no `enable` — mirroring `aspects/desktop/mango.nix`.
  # A user module that configures omniwm imports this so its settings are inert
  # on hosts without the aspect, rather than an eval error about undeclared
  # options. Do not also inject it from the darwin half below, or it would be
  # imported twice.
  flake.modules.homeManager.omniwm =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.programs.omniwm;
      tomlFormat = pkgs.formats.toml { };
    in
    {
      options.programs.omniwm = {
        enable = lib.mkEnableOption "OmniWM";

        package = lib.mkOption {
          type = lib.types.package;
          default = pkgs.callPackage ../../../pkgs/omniwm.nix { };
          defaultText = lib.literalExpression "pkgs.callPackage ./pkgs/omniwm.nix { }";
          description = "The OmniWM package to use.";
        };

        launchd = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Whether to manage OmniWM with a launchd agent.";
          };

          keepAlive = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Whether the launchd agent should be kept alive.";
          };
        };

        settings = lib.mkOption {
          type = with lib.types; either path tomlFormat.type;
          default = { };
          example = lib.literalExpression ''
            {
              general.updateChecksEnabled = false;
            }
          '';
          description = ''
            OmniWM settings written to
            {file}`$XDG_CONFIG_HOME/omniwm/settings.toml`. Either a path to an
            existing TOML file or an attrset that is serialized to TOML. See
            <https://github.com/BarutSRB/OmniWM> for the available keys.
          '';
        };
      };

      config = lib.mkIf cfg.enable {
        assertions = [
          (lib.hm.assertions.assertPlatform "programs.omniwm" pkgs lib.platforms.darwin)
        ];

        home.packages = [ cfg.package ];

        launchd.agents.omniwm = {
          inherit (cfg.launchd) enable;
          config = {
            Program = "${cfg.package}/Applications/OmniWM.app/Contents/MacOS/OmniWM";
            KeepAlive = cfg.launchd.keepAlive;
            RunAtLoad = true;
            StandardOutPath = "/tmp/omniwm.log";
            StandardErrorPath = "/tmp/omniwm.err.log";
          };
        };

        xdg.configFile."omniwm/settings.toml" = lib.mkIf (cfg.settings != { }) {
          source =
            if lib.hm.strings.isPathLike cfg.settings then
              cfg.settings
            else
              tomlFormat.generate "omniwm-settings.toml" cfg.settings;
        };
      };
    };

  # The host side owns enablement, as with every other aspect.
  flake.modules.darwin.omniwm = {
    home-manager.sharedModules = [ { programs.omniwm.enable = true; } ];
  };
}
