# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

NixOS + home-manager flake for two machines: `legion5` (AMD/NVIDIA hybrid laptop, mango Wayland desktop) and `elitedesk` (Intel, minimal/headless). It follows the **dendritic pattern**: `flake.nix` has no `outputs` logic of its own — it hands `inputs.import-tree ./modules` to `flake-parts`, which auto-imports *every* `.nix` file under `modules/` as a flake-parts module. There is no central import list anywhere.

## Commands

```bash
# Apply config to the current machine (host name must match a nixosConfigurations key)
sudo nixos-rebuild switch --flake .#legion5
sudo nixos-rebuild switch --flake .#elitedesk

# Test without making it the boot default
sudo nixos-rebuild test --flake .#legion5

# Evaluate every module and configuration the flake exposes
nix flake check

# Build one host's closure without root
nix build .#nixosConfigurations.legion5.config.system.build.toplevel

# Inspect one evaluated option instead of rebuilding the world
nix eval .#nixosConfigurations.legion5.config.networking.hostName
nix eval --json .#nixosModules --apply builtins.attrNames   # list all aspects

# Update all inputs, or just one
nix flake update
nix flake update mangowm
```

**`git add` new files before evaluating.** Flake evaluation reads the git tree, so a newly created `.nix` file is invisible to `nix flake check` / `nixos-rebuild` until it is at least staged. Because nothing imports files by path, the symptom is not "file not found" — it's `error: undefined variable 'foo'` from whichever module referenced the missing aspect, or an aspect silently absent from `nix eval .#nixosModules`.

There are no tests, linters, or CI. `nix flake check` plus a build are the only verification.

## Architecture

Every file under `modules/` is a flake-parts module that sets attributes under `flake.modules.<class>.<name>`. Nothing imports files by path; modules reference each other only through `self.nixosModules.<name>` / `self.homeModules.<name>`. Adding a file registers an aspect; renaming an attribute breaks every referrer.

`modules/parts.nix` is the only file that configures flake-parts itself. It imports three flake-parts/home-manager modules and does one important thing: `flake.modules.<class>.<name>` comes from `inputs.flake-parts.flakeModules.modules`, which types it as `lazyAttrsOf (lazyAttrsOf deferredModule)`. **That type is why any number of files may contribute to the same aspect name and merge** rather than conflict. `parts.nix` then republishes `flake.modules.nixos` / `flake.modules.homeManager` as the standard `flake.nixosModules` / `flake.homeModules` outputs, and uses `touchup` to keep the non-standard `modules` attribute out of the published outputs (otherwise every nix command warns about it).

### The four layers

```
modules/
  aspects/     cross-cutting features: core/ hardware/ desktop/
  profiles/    minimal.nix, desktop.nix — bundles of aspects
  hosts/       legion5/, elitedesk/ — machine facts + which aspects to enable
  users/aaron/ how aaron configures software, one file per aspect
```

- **Aspect** — one feature, spanning classes. `flake.modules.nixos.<name>` for the system side, `flake.modules.homeManager.<name>` for the home side, in the same file.
- **Profile** — `minimal` (bootloader, networking, ssh, locale, nix settings, state version, bash, home-manager) and `desktop` (= minimal + audio + bluetooth + xkb).
- **Host** — `flake.nixosConfigurations.<host>` plus `flake.modules.nixos.<host>`, which imports a profile, the aspects that host wants, the user entities that live there, and its own `<host>-hardware` / `<host>-nvidia` / `<host>-monitors` modules.
- **User** — `flake.modules.nixos.aaron` (the entity: `users.users.aaron` + `home-manager.users.aaron`) and `flake.modules.homeManager.aaron`, which `bash.nix`, `waybar.nix` and `mango.nix` each contribute to independently.

`nixosSystem` is called **without** a `system` argument — the platform comes from `nixpkgs.hostPlatform` in each host's `hardware.nix`. Don't add `system =` there.

Host `hardware.nix` files are `nixos-generate-config` output wrapped in `flake.modules.nixos.<host>-hardware`, carrying real disk UUIDs. Regenerating means re-wrapping, not overwriting.

## The core rule: hosts enable, users configure

**A host decides what software exists. A user decides how it behaves. User configuration for software the host never enabled does nothing.**

```nix
# modules/aspects/desktop/waybar.nix — the host side owns enablement
flake.modules.nixos.waybar = {
  home-manager.sharedModules = [ { programs.waybar.enable = true; } ];
};

# modules/users/aaron/waybar.nix — the user side owns settings, never `.enable`
flake.modules.homeManager.aaron = {
  programs.waybar.settings.main = { ... };
};
```

This needs no custom machinery: every home-manager program module is `config = mkIf cfg.enable {...}`, so settings without enable produce nothing and raise nothing. Verified — `elitedesk` imports the same `aaron` module carrying his waybar layout, foot config and all 73 mango binds, and generates no `waybar/config`, no `foot/foot.ini` and no `mango/config.conf`.

Consequences when editing:

- **Never put `.enable` in `modules/users/`.** Enablement belongs in an aspect.
- **Never put user preferences in an aspect.** An aspect may set enablement, system dependencies, and non-opinionated defaults — not keybinds, colors or layouts.
- **A user module configuring a third-party program must import that program's HM module.** Built-in home-manager options (`programs.waybar`, `programs.foot`, `programs.bash`) always exist, so nothing is needed. Mango's do not: `modules/users/aaron/mango.nix` imports `self.homeModules.mango`, which is an options-only module (`flake.modules.homeManager.mango` in `aspects/desktop/mango.nix` imports the upstream HM module but sets no `enable`). Without that import, configuring mango on a host lacking the aspect is an *undeclared option error*, not a no-op.
- **Aspects carry their own dependencies.** `aspects/desktop/mango.nix` provides `brightnessctl` and `swaybg` because its binds and autostart use them; `aspects/desktop/rofi.nix` provides `rofi` for the launcher bind. Don't add these to a host's `environment.systemPackages`.
- **Host-specific data goes in the host.** `hosts/legion5/monitors.nix` owns `monitorrule` (the `eDP-2`/`HDMI-A-1` panels) and the `amdgpu_bl2` brightness binds, injected via `home-manager.sharedModules`. Mango's `settings.bind` is a list and definitions **concatenate**, so a host may append binds to a user's set (verified: 71 user + 2 host = 73).

## Theming

`aspects/desktop/stylix.nix` (gruvbox-dark-medium, DejaVu/JetBrainsMono Nerd Font, `wallpapers/wallhaven-mountain1.jpg`) themes GTK/Qt/terminals/waybar globally. Prefer adding a stylix target over hand-writing colors.

`stylix.image` resolves to a store path and **is readable from home-manager as well as NixOS**. `aspects/desktop/wallpaper.nix` is the one place mango and stylix meet: it reads `config.stylix.image` at the NixOS level and contributes the `swaybg` line to mango's `autostart_sh` (a `types.lines` option, so it concatenates with the `waybar &` line from `users/aaron/mango.nix`). This keeps stylix the single source of truth for the wallpaper and means nothing depends on the repo's checkout path.

Mango's own colors (`focuscolor`, `bordercolor`, …) are set literally in `users/aaron/mango.nix` and are *not* stylix-driven — changing the scheme leaves those stale.

## Unfree packages

`allowUnfree` is never set globally. Each aspect or host declares only what it needs via `nixpkgs.config.allowUnfreePackages`:

- `hosts/legion5/configuration.nix` — `claude-code`, `vivaldi`
- `hosts/legion5/nvidia.nix` — `nvidia-x11`, `nvidia-settings`, `nvidia-persistenced`

`allowUnfreePackages` is safe to split across modules: `nixos/modules/misc/nixpkgs.nix` special-cases it to **concatenate** across definitions (alongside `packageOverrides`), while everything else in `nixpkgs.config` merges by `recursiveUpdate` and would silently clobber. Prefer it over `allowUnfreePredicate`, which is a function and therefore cannot be contributed to from two places.

An unfree violation does **not** surface from `nix flake check` — the throw is lazy, and `pkgs.foo.name` still evaluates. Force the derivation instead:

```bash
nix eval --raw .#nixosConfigurations.legion5.config.system.build.toplevel.drvPath
```

## Verifying a change

```bash
# 1. everything evaluates
nix flake check

# 2. force both closures — the only thing that catches unfree violations
nix eval --raw .#nixosConfigurations.legion5.config.system.build.toplevel.drvPath
nix eval --raw .#nixosConfigurations.elitedesk.config.system.build.toplevel.drvPath

# 3. the enable/configure rule still holds: aaron's desktop config must be
#    absent on elitedesk and present on legion5
nix eval --json .#nixosConfigurations.elitedesk.config.home-manager.users.aaron.xdg.configFile --apply builtins.attrNames
nix eval --json .#nixosConfigurations.legion5.config.home-manager.users.aaron.xdg.configFile --apply builtins.attrNames

# 4. review actual drift rather than trusting the hash
nix build --no-link --print-out-paths .#nixosConfigurations.legion5.config.system.build.toplevel
nix store diff-closures /run/current-system <that path>
```

## Conventions

- `system.stateVersion` and `home.stateVersion` are both `25.11`, set together in `aspects/core/state-version.nix`. Don't bump them, and don't set `home.stateVersion` again in a user module — it would conflict.
- 2-space indent, `nixfmt`-style formatting. Aspect files stay minimal, one concern per file, often 3–8 lines.
- Take no module arguments when none are needed: write `{ flake.modules.nixos.foo = { ... }; }`, not an unused `{ inputs, ... }:`.
- Aspect names are kebab-case and match the file path (`aspects/core/nix-settings.nix` → `nix-settings`). Host-scoped modules are prefixed: `legion5-hardware`, `legion5-monitors`, `legion5-nvidia`.
- The `nixcord` flake input is declared but currently unused.
