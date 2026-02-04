{ config, pkgs, ... }:
{
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
