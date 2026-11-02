{ den, lib, ... }:
{
  # user aspect
  den.aspects.aaron = {
    includes = [
      den._.define-user
      den._.primary-user
      (den._.user-shell "bash")

      den.aspects.aaron._.git
      den.aspects.aaron._.nvf
    ];

    provides.to-hosts =
      { host, ... }:
      lib.optionalAttrs (lib.elem "desktop" (host.roles or [ ])) {
        includes = [
          den.aspects.aaron._.foot
          den.aspects.aaron._.mango
          den.aspects.aaron._.nixcord
          den.aspects.aaron._.rofi
          den.aspects.aaron._.udiskie
          den.aspects.aaron._.waybar
        ];
      };
  };
}
