{ inputs, ... }: {
  den.aspects.aaron.provides.waybar.homeManager = { pkgs, ... }:
    let
      wgStatus = pkgs.writeShellScript "wg0-status" ''
        if [ -e /sys/class/net/wg0 ]; then
          echo '{"text":"VPN ◆","class":"on","tooltip":"wg0 up · click to disconnect"}'
        else
          echo '{"text":"VPN ◇","class":"off","tooltip":"wg0 down · click to connect"}'
        fi
      '';
      wgToggle = pkgs.writeShellScript "wg0-toggle" ''
        if [ -e /sys/class/net/wg0 ]; then
          nmcli connection down wg0
        else
          nmcli connection up wg0
        fi
        ${pkgs.procps}/bin/pkill -RTMIN+8 waybar
      '';
    in {
    programs.waybar = {
      enable = true;
      package = inputs.waybar.packages.${pkgs.stdenv.hostPlatform.system}.waybar;

      settings.main = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 4;

        modules-left = [
          "mango/workspaces"
          "mango/layout"
        ];

        modules-center = [
          "clock"
        ];

        modules-right = [
          "pulseaudio"
          "network"
          "battery"
        ];

        # Geometric shapes rather than Nerd Font private-use glyphs: an empty
        # string here is truthy to jsoncpp, so a stripped codepoint silently
        # short-circuits getIcon's fallbacks and renders a blank bar.
        "mango/workspaces" = {
          format = "{icon}";
          format-icons = {
            active = "●";
            default = "○";
            urgent = "◉";
            empty = "·";
          };

          on-click = "activate";
          on-click-right = "toggle";
        };

        # Follows the default sink, so it tracks whichever output is active.
        # Glyphs are BMP for the same reason as the workspace pips above.
        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-muted = "✕ {volume}%";
          format-icons = {
            headphone = "♫";
            headset = "♫";
            default = "♪";
          };

          tooltip-format = "{desc}";
          scroll-step = 5;
          max-volume = 100;
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };

        "network" = {
          format-wifi = "{essid} ({signalStrength}%)";
          format-ethernet = "{ifname}";
          format-linked = "{ifname} (no IP)";
          format-disconnected = "offline";
          tooltip-format-wifi = "{essid} · {ipaddr}/{cidr} · {frequency} GHz";
          tooltip-format-ethernet = "{ifname} · {ipaddr}/{cidr}";
          on-click = "foot nmtui";
        };
      };

      # Stylix styles these buttons but sets no metrics, so without padding they
      # collapse to their border.
      style = ''
        #workspaces button {
          padding: 0 4px;
        }
      '';
    };
  };
}