# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

NixOS + nix-darwin + home-manager flake for three machines: `legion5` (AMD/NVIDIA hybrid laptop, mango Wayland desktop), `elitedesk` (Intel, minimal/headless) and `aarons-macbook` (Apple Silicon, nix-darwin). It follows the **dendritic pattern**: `flake.nix` has no `outputs` logic of its own — it hands `inputs.import-tree ./modules` to `flake-parts`, which auto-imports *every* `.nix` file under `modules/` as a flake-parts module. There is no central import list anywhere.

## Commands

```bash
# Apply config to the current machine (host name must match a configurations key)
sudo nixos-rebuild switch --flake .#legion5
sudo nixos-rebuild switch --flake .#elitedesk
darwin-rebuild switch --flake .#aarons-macbook          # on the Mac; no sudo

# Test without making it the boot default
sudo nixos-rebuild test --flake .#legion5

# Evaluate every module and configuration the flake exposes
nix flake check

# Build one host's closure without root
nix build .#nixosConfigurations.legion5.config.system.build.toplevel

# Inspect one evaluated option instead of rebuilding the world
nix eval .#nixosConfigurations.legion5.config.networking.hostName
nix eval .#darwinConfigurations.aarons-macbook.config.system.stateVersion

# List the aspects available to each class
nix eval --json .#nixosModules  --apply builtins.attrNames
nix eval --json .#darwinModules --apply builtins.attrNames
nix eval --json .#homeModules   --apply builtins.attrNames

# Update all inputs, or just one
nix flake update
nix flake update mangowm
```

**`git add` new files before evaluating.** Flake evaluation reads the git tree, so a newly created `.nix` file is invisible to `nix flake check` / `nixos-rebuild` until it is at least staged. Because nothing imports files by path, the symptom is not "file not found" — it's `error: undefined variable 'foo'` from whichever module referenced the missing aspect, or an aspect silently absent from `nix eval .#nixosModules`.

There are no tests, linters, or CI. `nix flake check` plus a build are the only verification.

## Architecture

Every file under `modules/` is a flake-parts module that sets attributes under `flake.modules.<class>.<name>`. Nothing imports files by path; modules reference each other only through `self.nixosModules.<name>` / `self.homeModules.<name>`. Adding a file registers an aspect; renaming an attribute breaks every referrer.

`modules/parts.nix` is the only file that configures flake-parts itself, and the only place that knows about module classes. It does three things:

1. Imports `inputs.flake-parts.flakeModules.modules`, which declares `flake.modules.<class>.<name>` as `lazyAttrsOf (lazyAttrsOf deferredModule)`. **That type is why any number of files may contribute to the same aspect name and merge** rather than conflict, and its `apply` tags each module with the right `_class`.
2. Declares `flake.darwinModules` itself. nix-darwin's `flakeModules.default` declares `flake.darwinConfigurations` and *nothing else*, so there is no upstream counterpart to `flake.nixosModules`; `parts.nix` mirrors flake-parts' own `modules/nixosModules.nix` declaration with `_class = "darwin"` (which is the class nix-darwin's `eval-config.nix` evaluates with).
3. Republishes `flake.modules.{nixos,darwin,homeManager}` as the standard `flake.{nixosModules,darwinModules,homeModules}` outputs, and uses `touchup` to keep the non-standard `modules` attribute out of the published outputs (otherwise every nix command warns about it).

### The four layers

```
modules/
  aspects/     cross-cutting features: core/ hardware/ desktop/ services/ tools/
  profiles/    minimal.nix (nixos + darwin), desktop.nix — bundles of aspects
  hosts/       legion5/, elitedesk/, aarons-macbook/ — machine facts + aspects to enable
  users/aaron/ how aaron configures software, one file per aspect
```

- **Aspect** — one feature, spanning classes. `flake.modules.nixos.<name>`, `flake.modules.darwin.<name>` and `flake.modules.homeManager.<name>` may all be set in the same file.
- **Profile** — `minimal` is defined for *both* system classes in one file; `desktop` (= minimal + audio + bluetooth + xkb) is NixOS-only.
- **Host** — `flake.nixosConfigurations.<host>` or `flake.darwinConfigurations.<host>`, plus `flake.modules.{nixos,darwin}.<host>` importing a profile, the aspects that host wants, the user entities living there, and its own `<host>-hardware` / `<host>-nvidia` / `<host>-monitors` modules.
- **User** — `flake.modules.nixos.aaron` and `flake.modules.darwin.aaron` (the entity, per class) plus one class-agnostic `flake.modules.homeManager.aaron` that `bash.nix`, `btop.nix`, `waybar.nix` and `mango.nix` each contribute to independently.

### One user, two account names

The macOS account is SSO-managed and called `aaron.davis`; the NixOS account is `aaron`. **The aspect name stays `aaron` on both classes** — only the entity module in `users/aaron/user.nix` knows the real login name:

```nix
flake.modules.darwin.aaron =
  let account = "aaron.davis"; in {
    users.users.${account}.home = "/Users/${account}";
    system.primaryUser = account;
    home-manager.users.${account} = self.homeModules.aaron;   # same module
  };
```

This works without any renaming machinery because home-manager derives identity from the account entry rather than from the module: `nixos/common.nix` sets `home.username = config.users.users.<name>.name` and `home.homeDirectory = config.users.users.<name>.home`. So `homeModules.aaron` never mentions a username or home path and must stay that way — writing `/home/aaron` anywhere in `users/aaron/` would break the Mac.

Verified: `home.username` / `home.homeDirectory` come out as `aaron` + `/home/aaron` on the NixOS hosts and `aaron.davis` + `/Users/aaron.davis` on the Mac, from one set of user files.

Note the consequence when inspecting the Mac: home-manager is keyed by account, so the eval path is `home-manager.users."aaron.davis"`, not `.users.aaron`.

Neither `nixosSystem` nor `darwinSystem` is given a `system` argument — the platform comes from `nixpkgs.hostPlatform` in each host's `hardware.nix`. Don't add `system =` there.

The NixOS hosts' `hardware.nix` files are `nixos-generate-config` output wrapped in `flake.modules.nixos.<host>-hardware`, carrying real disk UUIDs; regenerating means re-wrapping, not overwriting. `aarons-macbook/hardware.nix` has no such counterpart — macOS owns the disks and boot, so it states only the platform.

### Writing an aspect that cross-cuts classes

Class namespaces are independent, so the same aspect name can exist in several. When the configuration is identical, define it once in a `let` and assign it to each class — no helper or abstraction needed:

```nix
# modules/aspects/tools/btop.nix
let
  shared = {
    home-manager.sharedModules = [ { programs.btop.enable = true; } ];
  };
in
{
  flake.modules.nixos.btop = shared;
  flake.modules.darwin.btop = shared;
}
```

When the classes genuinely diverge, write both halves explicitly in the one file rather than splitting the feature across two — that is the whole point of an aspect. Two live examples:

- `aspects/core/state-version.nix` — NixOS takes a release *string* (`"25.11"`), nix-darwin takes an *integer* (`types.ints.between 1 maxStateVersion`, currently 7). The class-agnostic `home.stateVersion` half is shared by both via a `let`.
- `aspects/core/home-manager.nix` — same `useGlobalPkgs`/`useUserPackages` settings, but `home-manager.nixosModules.default` vs `home-manager.darwinModules.default` as the entrypoint.

Things with no darwin counterpart (bootloader, NetworkManager, sshd, i18n, `virtualisation.docker`, and everything in `aspects/desktop/`) simply define no `darwin` attribute, so `self.darwinModules.waybar` does not exist and a Mac cannot import it by mistake.

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

This needs no custom machinery: every home-manager program module is `config = mkIf cfg.enable {...}`, so settings without enable produce nothing and raise nothing. **The rule holds across classes**, because `homeModules.aaron` is class-agnostic and follows him to every machine:

| aaron's module defines | legion5 | elitedesk | aarons-macbook |
| --- | --- | --- | --- |
| bash aliases | ✅ | ✅ | ✅ |
| btop settings | ✅ `btop-cuda` | ✅ `btop-cuda` | ✅ plain `btop` |
| waybar layout | ✅ `waybar/config` | inert | inert |
| 73 mango binds | ✅ `mango/config.conf` | inert | inert |

"inert" means the options are defined and evaluate cleanly, but produce no file and no package: `elitedesk` and `aarons-macbook` both carry aaron's waybar layout and all 73 mango binds in their evaluated config, and neither generates `waybar/config` or `mango/config.conf`.

btop is the clearest illustration of the split going the other way. All three hosts share one set of user settings (`users/aaron/btop.nix`), while each host picks the package by choosing which aspect to import — verified by `programs.btop.package.drvPath`:

| host | aspect imported | resolves to |
| --- | --- | --- |
| legion5, elitedesk | `btop-cuda` | `1p6mygwg…-btop-1.4.7.drv` |
| aarons-macbook | `btop` | darwin's plain `btop` |

Note that `btop` and `btop-cuda` share the same derivation *name* (`btop-1.4.7`), so comparing `package.name` cannot tell them apart — compare `package.drvPath`.

Consequences when editing:

- **Never put `.enable` in `modules/users/`.** Enablement belongs in an aspect.
- **Never put user preferences in an aspect.** An aspect may set enablement, system dependencies, and non-opinionated defaults — not keybinds, colors or layouts.
- **A user module configuring a third-party program must import that program's HM module.** Built-in home-manager options (`programs.waybar`, `programs.foot`, `programs.bash`) always exist, so nothing is needed. Mango's do not: `modules/users/aaron/mango.nix` imports `self.homeModules.mango`, which is an options-only module (`flake.modules.homeManager.mango` in `aspects/desktop/mango.nix` imports the upstream HM module but sets no `enable`). Without that import, configuring mango on a host lacking the aspect is an *undeclared option error*, not a no-op.
- **Aspects carry their own dependencies.** `aspects/desktop/mango.nix` provides `brightnessctl` and `swaybg` because its binds and autostart use them; `aspects/desktop/rofi.nix` provides `rofi` for the launcher bind. Don't add these to a host's `environment.systemPackages`.
- **Package variants are separate aspects that refine the base**, not a second copy of it. `flake.modules.nixos.btop-cuda` in `aspects/tools/btop.nix` does `imports = [ self.nixosModules.btop ]` and then overrides `programs.btop.package`, so a host imports exactly one of `btop` / `btop-cuda` and enablement is never stated twice.
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

# 2. force all three closures — the only thing that catches unfree violations.
#    The darwin one evaluates fine from Linux (it just can't be built there).
nix eval --raw .#nixosConfigurations.legion5.config.system.build.toplevel.drvPath
nix eval --raw .#nixosConfigurations.elitedesk.config.system.build.toplevel.drvPath
nix eval --raw .#darwinConfigurations.aarons-macbook.config.system.build.toplevel.drvPath

# 3. the enable/configure rule still holds: aaron's desktop config must be
#    absent on elitedesk and aarons-macbook, present on legion5
nix eval --json .#nixosConfigurations.elitedesk.config.home-manager.users.aaron.xdg.configFile --apply builtins.attrNames
nix eval --json .#nixosConfigurations.legion5.config.home-manager.users.aaron.xdg.configFile --apply builtins.attrNames
nix eval --json .#darwinConfigurations.aarons-macbook.config.home-manager.users.\"aaron.davis\".xdg.configFile --apply builtins.attrNames

# 4. review actual drift rather than trusting the hash
nix build --no-link --print-out-paths .#nixosConfigurations.legion5.config.system.build.toplevel
nix store diff-closures /run/current-system <that path>
```

## Conventions

- State versions all live in `aspects/core/state-version.nix`: `25.11` for NixOS and home-manager, `7` for nix-darwin. Don't bump them, and don't set `home.stateVersion` again in a user module — it would conflict.
- 2-space indent, `nixfmt`-style formatting. Aspect files stay minimal, one concern per file, often 3–8 lines.
- Take no module arguments when none are needed: write `{ flake.modules.nixos.foo = { ... }; }`, not an unused `{ inputs, ... }:`. A file that only shares a `let` between classes needs no arguments at all.
- Aspect names are kebab-case and match the file path (`aspects/core/nix-settings.nix` → `nix-settings`). Host-scoped modules are prefixed: `legion5-hardware`, `legion5-monitors`, `aarons-macbook-hardware`.
- The `nixcord` flake input is declared but currently unused.
