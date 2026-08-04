{
  # darwin-only: there is no Homebrew on NixOS, so no `nixos` attribute exists
  # and a NixOS host cannot import this by mistake.
  #
  # This does **not** install Homebrew. nix-darwin only generates a Brewfile and
  # runs `brew bundle` during activation; with brew missing, activation prints
  # "error: Homebrew is not installed, skipping..." and moves on. Install it
  # once by hand from https://brew.sh.
  flake.modules.darwin.homebrew = {
    homebrew = {
      enable = true;

      # Leave anything installed by hand alone. Setting this to "uninstall" or
      # "zap" makes this flake the sole owner of Homebrew's state and will
      # remove every brew and cask not declared here.
      onActivation.cleanup = "none";
    };
  };
}
