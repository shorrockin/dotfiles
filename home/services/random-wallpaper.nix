{ config, pkgs, ... }:
{
  # Wallpaper daemon. Renders whatever ~/.cache/current_wallpaper.png points at
  # (a symlink maintained by the random-wallpaper script). Lightweight: swaybg
  # hands the compositor a shared-memory buffer instead of holding its own GL
  # context, so it costs ~15 MB instead of hyprpaper's ~330 MB on NVIDIA.
  systemd.user.services.swaybg = {
    Unit = {
      Description = "Wallpaper daemon (swaybg)";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.swaybg}/bin/swaybg -i ${config.home.homeDirectory}/.cache/current_wallpaper.png -m fill";
      Restart = "on-failure";
      RestartSec = 1;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  systemd.user.services.random-wallpaper = {
    Unit.Description = "Randomize wallpaper";
    Service = {
      Type = "oneshot";
      ExecStart = "${config.home.homeDirectory}/.config/scripts/random-wallpaper";
    };
  };

  systemd.user.timers.random-wallpaper = {
    Unit.Description = "Run wallpaper change script every hour";
    Timer = {
      OnCalendar = "hourly";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
