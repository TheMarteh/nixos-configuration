# Vergrendelen, vanzelf uitgaan, en een screensaver.
#
# hyprlock leest zijn kleuren uit ~/.config/current-theme (zie home/theme.nix);
# daarom niet via programs.hyprlock, want die schrijft de instellingen naar de
# store en dan staat het palet vast bij de build.
{
  config,
  pkgs,
  ...
}:

let
  hyprConfig = "${config.home.homeDirectory}/nixos-configuration/config/hypr";
  link = path: config.lib.file.mkOutOfStoreSymlink path;

  # Sinds Hyprland 0.55 leest `hyprctl dispatch` zijn argument als Lua. De oude
  # vorm (`hyprctl dispatch dpms off`) geeft een parsefout en doet niets.
  dpms = state: ''hyprctl dispatch 'hl.dsp.dpms("${state}")' '';

  banner = pkgs.writeText "screensaver-banner" ''
    ███╗   ██╗██╗██╗  ██╗ ██████╗ ███████╗
    ████╗  ██║██║╚██╗██╔╝██╔═══██╗██╔════╝
    ██╔██╗ ██║██║ ╚███╔╝ ██║   ██║███████╗
    ██║╚██╗██║██║ ██╔██╗ ██║   ██║╚════██║
    ██║ ╚████║██║██╔╝ ██╗╚██████╔╝███████║
    ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝
  '';

  screensaver = pkgs.writeShellApplication {
    name = "screensaver";
    runtimeInputs = [
      pkgs.jq
      pkgs.terminaltexteffects
    ];
    text = ''
      # Al zichtbaar? Dan niet nog een keer.
      if hyprctl clients -j | jq -e 'any(.[]; .class == "Screensaver")' >/dev/null; then
          exit 0
      fi

      # De window rule in config/hypr/windowrules.lua maakt hier een
      # schermvullend, randloos venster van. In de achtergrond, zodat hypridle
      # niet blijft wachten tot hij weer weg is.
      uwsm app -- alacritty --class Screensaver -e bash -c \
          "tte -i ${banner} -R --anchor-canvas c --anchor-text c; read -rsn1" &
    '';
  };

  screensaver-stop = pkgs.writeShellApplication {
    name = "screensaver-stop";
    runtimeInputs = [ pkgs.jq ];
    text = ''
      if hyprctl clients -j | jq -e 'any(.[]; .class == "Screensaver")' >/dev/null; then
          hyprctl dispatch 'hl.dsp.window.close(hl.get_windows({ class = "Screensaver" })[1])' >/dev/null
      fi
    '';
  };

  # Voor films en presentaties: laat het scherm niet vanzelf uitgaan.
  present-mode = pkgs.writeShellApplication {
    name = "present-mode";
    text = ''
      if systemctl --user is-active --quiet hypridle.service; then
          systemctl --user stop hypridle.service
          notify-send -a present-mode "Presenteermodus aan" \
              "Het scherm gaat niet meer vanzelf uit." || true
      else
          systemctl --user start hypridle.service
          notify-send -a present-mode "Presenteermodus uit" \
              "Het scherm gaat weer vanzelf uit." || true
      fi
    '';
  };
in
{
  home.packages = [
    pkgs.hyprlock
    screensaver
    screensaver-stop
    present-mode
  ];

  xdg.configFile."hypr/hyprlock.conf".source = link "${hyprConfig}/hyprlock.conf";

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        # Zonder deze check start er een tweede hyprlock bovenop de eerste.
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = dpms "on";
      };

      # Deze machine is een desktop zonder accu, dus bewust geen suspend.
      listener = [
        {
          timeout = 300;
          on-timeout = "screensaver";
          on-resume = "screensaver-stop";
        }
        {
          timeout = 600;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 660;
          on-timeout = dpms "off";
          on-resume = dpms "on";
        }
      ];
    };
  };
}
