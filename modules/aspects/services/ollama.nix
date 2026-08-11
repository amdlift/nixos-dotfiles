{
  # darwin-only: nix-darwin has no `services.ollama` (the option exists on the
  # NixOS class only), so the daemon is a plain launchd user agent. No `nixos`
  # attribute, so a NixOS host cannot import this by mistake.
  flake.modules.darwin.ollama =
    { pkgs, ... }:
    {
      # nixpkgs' ollama is CLI + server: the derivation does `rm -r app`, so
      # there is no menubar app and nothing auto-starts the server for us.
      environment.systemPackages = [ pkgs.ollama ];

      # Without a running server `ollama run` fails with "could not connect to
      # ollama app". The agent runs as `system.primaryUser`, so models live in
      # that account's ~/.ollama.
      #
      # `command` rather than a hand-written `ProgramArguments`: nix-darwin wraps
      # it in `/bin/wait4path /nix/store && exec …`, which is what keeps the
      # agent from firing at login before the Nix store is mounted.
      launchd.user.agents.ollama = {
        command = "${pkgs.ollama}/bin/ollama serve";

        serviceConfig = {
          RunAtLoad = true;
          KeepAlive = true;

          # launchd does not expand `~` here, and an aspect must not spell out
          # an account's home path, so the logs go to /tmp.
          StandardOutPath = "/tmp/ollama.log";
          StandardErrorPath = "/tmp/ollama.err.log";
        };
      };
    };
}
